import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'period_lengths.dart';

/// Starting, ending, and removing periods by long-pressing Calendar days,
/// plus reading them back for the Calendar. See "Period tracking" in
/// CLAUDE.md for the rules.
///
/// Every method only ever reads or writes the signed-in user's own data.
class PeriodEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // A long-press up to this many days after a period's start (i.e. up to
  // its 10th day) ends that period. Further away, it starts a new one.
  // The same distance before a period's start moves that start earlier.
  static const _maxDaysFromStart = 9;

  /// Applies a long-press on [date] and returns what happened, so the app
  /// can describe it and offer Undo. In order:
  ///
  /// 1. On a period's start date: removes that period.
  /// 2. Up to the 10th day of the latest period that started before it (or
  ///    anywhere inside that period's assumed days): sets it as the end.
  /// 3. Up to 9 days before the next period's start: moves that start
  ///    earlier to [date], rather than creating an overlapping period.
  /// 4. Otherwise: starts a new period on [date], with an assumed end.
  ///
  /// Throws for future dates — periods can only be logged for today or
  /// earlier.
  Future<PeriodChange> longPress(Session session, DateTime date) async {
    final userId = session.authenticated!.authUserId;
    final day = _dateOnly(date);
    if (day.isAfter(_today())) {
      throw ArgumentError("Periods can't be logged for future dates.");
    }

    final periods = await Period.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.startDate,
    );
    final defaultLength = (await computeDefaultPeriodLength(
      session,
      userId,
    )).days;

    // 1. Long-press on a start date removes that period.
    for (final period in periods) {
      if (period.startDate == day) {
        await Period.db.deleteRow(session, period);
        return PeriodChange(
          kind: PeriodChangeKind.removed,
          lengthDays: 0,
          before: period,
        );
      }
    }

    // 2. Inside or just after the latest period that began before [day]
    // sets its end.
    final previous = periods.lastWhereOrNull(
      (p) => p.startDate.isBefore(day),
    );
    if (previous != null) {
      final daysFromStart = day.difference(previous.startDate).inDays;
      final insideAssumedDays = !day.isAfter(
        effectiveEndDate(previous, defaultLength),
      );
      if (daysFromStart <= _maxDaysFromStart || insideAssumedDays) {
        final ended = await Period.db.updateRow(
          session,
          previous.copyWith(endDate: day),
        );
        return PeriodChange(
          kind: PeriodChangeKind.ended,
          lengthDays: daysFromStart + 1,
          before: previous,
          after: ended,
        );
      }
    }

    // 3. Just before the next period moves its start earlier.
    final next = periods.firstWhereOrNull((p) => p.startDate.isAfter(day));
    if (next != null &&
        next.startDate.difference(day).inDays <= _maxDaysFromStart) {
      final moved = await Period.db.updateRow(
        session,
        next.copyWith(startDate: day),
      );
      return PeriodChange(
        kind: PeriodChangeKind.moved,
        lengthDays: _lengthOf(moved, defaultLength),
        before: next,
        after: moved,
      );
    }

    // 4. Otherwise, a new period starts here.
    final started = await Period.db.insertRow(
      session,
      Period(userId: userId, startDate: day),
    );
    return PeriodChange(
      kind: PeriodChangeKind.started,
      lengthDays: defaultLength,
      after: started,
    );
  }

  /// Reverses a change returned by [longPress] (the "Undo" button).
  Future<void> undo(Session session, PeriodChange change) async {
    final userId = session.authenticated!.authUserId;
    final before = change.before;
    final after = change.after;

    if (after != null) {
      // Only ever touch a row that really belongs to the signed-in user.
      final current = await Period.db.findById(session, after.id!);
      if (current == null || current.userId != userId) {
        throw ArgumentError('Period not found.');
      }
      if (before == null) {
        await Period.db.deleteRow(session, current);
      } else {
        await Period.db.updateRow(
          session,
          current.copyWith(
            startDate: before.startDate,
            endDate: before.endDate,
          ),
        );
      }
    } else if (before != null) {
      // A removed period: put it back, always under the signed-in user.
      await Period.db.insertRow(
        session,
        Period(
          userId: userId,
          startDate: before.startDate,
          endDate: before.endDate,
        ),
      );
    }
  }

  /// Every period overlapping [start]..[end] (inclusive days), with
  /// assumed end dates filled in, ordered by start date.
  Future<List<PeriodSpan>> getPeriods(
    Session session,
    DateTime start,
    DateTime end,
  ) async {
    final userId = session.authenticated!.authUserId;
    final rangeStart = _dateOnly(start);
    final rangeEnd = _dateOnly(end);
    final defaultLength = (await computeDefaultPeriodLength(
      session,
      userId,
    )).days;

    // A period starting before the range can still reach into it, so look
    // back far enough to catch the longest one possible.
    final periods = await Period.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.startDate.between(
            rangeStart.subtract(const Duration(days: 31)),
            rangeEnd,
          ),
      orderBy: (t) => t.startDate,
    );

    return [
      for (final period in periods)
        if (!effectiveEndDate(period, defaultLength).isBefore(rangeStart))
          PeriodSpan(
            periodId: period.id!,
            startDate: period.startDate,
            endDate: effectiveEndDate(period, defaultLength),
            endConfirmed: period.endDate != null,
          ),
    ];
  }

  /// The signed-in user's default period length and where it comes from
  /// (shown read-only on Me).
  Future<PeriodLengthInfo> getDefaultPeriodLength(Session session) =>
      computeDefaultPeriodLength(session, session.authenticated!.authUserId);

  int _lengthOf(Period period, int defaultLength) =>
      effectiveEndDate(
        period,
        defaultLength,
      ).difference(period.startDate).inDays +
      1;

  DateTime _today() => _dateOnly(DateTime.now().toUtc());

  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}

extension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T) test) {
    for (final item in reversed) {
      if (test(item)) return item;
    }
    return null;
  }
}
