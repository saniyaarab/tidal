import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../period/period_lengths.dart';

/// Turns the signed-in user's periods into cycle predictions, and manages
/// the `CycleSettings` collected at sign-up (cycle length, period length,
/// birth year).
///
/// Predictions themselves are never persisted — every call recomputes them
/// from the user's `Period` rows, so starting, ending, or removing a period
/// is reflected immediately with no separate record to keep in sync. Age is
/// the same way: only birth year is stored, and age is always computed
/// fresh from it, so it's never stale.
class InsightEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // The luteal phase (ovulation to next period) is far more consistent
  // across cycles than the follicular phase, so ovulation is estimated
  // this many days before the *next* period rather than from cycle start.
  static const _lutealPhaseDays = 14;

  // An egg is viable for about a day and sperm can survive about five, so
  // the fertile window opens this many days before the estimated ovulation
  // day and closes on it.
  static const _fertileWindowLeadDays = 5;

  // "Average of the last 3-6 cycle lengths" per the product spec: use up to
  // this many of the most recent completed cycles.
  static const _maxCyclesToAverage = 6;

  static const _minCycleLengthDays = 15;
  static const _maxCycleLengthDays = 45;

  // Cycles longer than this (e.g. a forgotten or missed period) are still
  // reported, but left out of the average so one gap doesn't push every
  // future prediction late. Not flagged to the user yet — anomaly warnings
  // are a future feature.
  static const _maxCycleDaysToAverage = 45;
  static const _minPeriodLengthDays = 1;
  static const _maxPeriodLengthDays = 14;

  // Sanity bounds on birth year, not a claim about who can menstruate:
  // younger than this is almost certainly a typo, older is almost certainly
  // a test.
  static const _minAgeYears = 8;
  static const _maxAgeYears = 100;

  // A sign-up guess is less trustworthy than even one measured cycle, so it
  // gets a wider confidence band than _spread()'s single-cycle fallback.
  static const _seedConfidenceDays = 4;

  Future<Prediction> getPrediction(Session session) async {
    final userId = session.authenticated!.authUserId;

    final periods = await Period.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.startDate,
    );
    final periodStarts = [for (final period in periods) period.startDate];

    if (periodStarts.isEmpty) {
      return Prediction();
    }

    final lastStart = periodStarts.last;
    final currentCycleDay = _todayAsDateKey().difference(lastStart).inDays + 1;
    final settings = await _getSettingsOrDefault(session);
    final periodLength = (await computeDefaultPeriodLength(
      session,
      userId,
    )).days;

    // Every completed cycle, oldest first, then the most recent few of them.
    final allCycles = [
      for (var i = 1; i < periodStarts.length; i++)
        CycleLength(
          startDate: periodStarts[i - 1],
          days: periodStarts[i].difference(periodStarts[i - 1]).inDays,
          excludedFromAverage:
              periodStarts[i].difference(periodStarts[i - 1]).inDays >
              _maxCycleDaysToAverage,
        ),
    ];
    final recentCycles = allCycles.length > _maxCyclesToAverage
        ? allCycles.sublist(allCycles.length - _maxCyclesToAverage)
        : allCycles;
    final lengthsToAverage = [
      for (final cycle in recentCycles)
        if (!cycle.excludedFromAverage) cycle.days,
    ];

    int nextCycleLength;
    int confidenceDays;
    if (lengthsToAverage.isEmpty) {
      // No usable completed cycle yet — seed from what the user told us at
      // sign-up, until there's real history to measure instead.
      nextCycleLength = settings.typicalCycleDays;
      confidenceDays = _seedConfidenceDays;
    } else {
      final avgLength =
          lengthsToAverage.reduce((a, b) => a + b) / lengthsToAverage.length;
      nextCycleLength = avgLength.round();
      confidenceDays = _spread(lengthsToAverage);
    }

    final nextStart = lastStart.add(Duration(days: nextCycleLength));
    final ovulationDay = nextStart.subtract(
      const Duration(days: _lutealPhaseDays),
    );

    return Prediction(
      lastPeriodStart: lastStart,
      currentCycleDay: currentCycleDay,
      nextPeriodStart: nextStart,
      confidenceDays: confidenceDays,
      predictedPeriodEnd: nextStart.add(Duration(days: periodLength - 1)),
      fertileWindowStart: ovulationDay.subtract(
        const Duration(days: _fertileWindowLeadDays),
      ),
      fertileWindowEnd: ovulationDay,
      recentCycles: recentCycles,
    );
  }

  /// Whether the signed-in user has completed sign-up's cycle length /
  /// period length / birth year step. Gates that one-time flow — it stays
  /// false until birth year is saved, even if cycle/period length were
  /// saved earlier (e.g. before this field existed).
  Future<bool> hasCycleSettings(Session session) async {
    final userId = session.authenticated!.authUserId;
    final existing = await CycleSettings.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return existing?.birthYear != null;
  }

  /// The signed-in user's saved birth year, or null if they haven't set one.
  Future<int?> getBirthYear(Session session) async {
    return (await _getSettingsOrDefault(session)).birthYear;
  }

  /// Saves the signed-in user's birth year, used to compute [getAge]. Only
  /// the year is ever asked for or stored — see `CycleSettings.birthYear`.
  Future<void> saveBirthYear(Session session, int year) async {
    final currentYear = _todayAsDateKey().year;
    if (year > currentYear) {
      throw ArgumentError('year cannot be in the future');
    }
    final age = currentYear - year;
    if (age < _minAgeYears || age > _maxAgeYears) {
      throw ArgumentError(
        'age must be between $_minAgeYears and $_maxAgeYears',
      );
    }
    await _upsertSettings(session, (s) => s.copyWith(birthYear: year));
  }

  /// The signed-in user's current age in years, computed from their saved
  /// birth year. Null if they haven't set one. Since only the year is
  /// known (never the month or day), this can be one year ahead of the
  /// true age until their actual birthday passes each year.
  Future<int?> getAge(Session session) async {
    final birthYear = await getBirthYear(session);
    if (birthYear == null) return null;
    return _todayAsDateKey().year - birthYear;
  }

  /// Typical days between period starts. Defaults to 28 until the user sets
  /// their own (at sign-up, or later from Me).
  Future<int> getCycleLength(Session session) async {
    return (await _getSettingsOrDefault(session)).typicalCycleDays;
  }

  /// Saves how many days typically pass between period starts. Only used
  /// to seed predictions before 2+ periods have been logged — once they
  /// have, the real average of logged cycles takes over automatically.
  Future<void> saveCycleLength(Session session, int days) async {
    if (days < _minCycleLengthDays || days > _maxCycleLengthDays) {
      throw ArgumentError(
        'days must be between $_minCycleLengthDays and $_maxCycleLengthDays',
      );
    }
    await _upsertSettings(session, (s) => s.copyWith(typicalCycleDays: days));
  }

  /// How many days the signed-in user's period usually lasts. Defaults to
  /// 5 until they set their own.
  Future<int> getPeriodLength(Session session) async {
    return (await _getSettingsOrDefault(session)).typicalPeriodDays;
  }

  /// Saves how many days the signed-in user's period usually lasts. Only
  /// allowed during sign-up (before birth year completes it) — afterwards
  /// the default comes from the user's own recorded periods instead (see
  /// `computeDefaultPeriodLength`), and Me only shows it.
  Future<void> savePeriodLength(Session session, int days) async {
    if (await hasCycleSettings(session)) {
      throw ArgumentError('Period length can only be set during sign-up.');
    }
    if (days < _minPeriodLengthDays || days > _maxPeriodLengthDays) {
      throw ArgumentError(
        'days must be between $_minPeriodLengthDays and $_maxPeriodLengthDays',
      );
    }
    await _upsertSettings(
      session,
      (s) => s.copyWith(typicalPeriodDays: days),
    );
  }

  /// The signed-in user's saved cycle settings, or defaults (28/5) if
  /// they've never saved any. Never persists the defaults — [hasCycleSettings]
  /// stays false until the user actually saves something.
  Future<CycleSettings> _getSettingsOrDefault(Session session) async {
    final userId = session.authenticated!.authUserId;
    final existing = await CycleSettings.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return existing ?? CycleSettings(userId: userId);
  }

  Future<void> _upsertSettings(
    Session session,
    CycleSettings Function(CycleSettings current) update,
  ) async {
    final userId = session.authenticated!.authUserId;
    final existing = await CycleSettings.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (existing == null) {
      await CycleSettings.db.insertRow(
        session,
        update(CycleSettings(userId: userId)),
      );
    } else {
      await CycleSettings.db.updateRow(session, update(existing));
    }
  }

  /// "± spread" around the average: half the gap between the shortest and
  /// longest recent cycle. A single completed cycle has no spread to
  /// measure, so a small default stands in for it — a zero-width prediction
  /// would read as more precise than the data supports.
  int _spread(List<int> lengths) {
    if (lengths.length == 1) return 2;
    final shortest = lengths.reduce(min);
    final longest = lengths.reduce(max);
    return ((longest - shortest) / 2).round().clamp(1, 7);
  }

  DateTime _todayAsDateKey() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }
}
