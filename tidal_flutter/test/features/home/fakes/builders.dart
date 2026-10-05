import 'package:tidal_client/tidal_client.dart';

/// Small builders for generated models, with the fields tests don't care
/// about filled in.
final testUserId = UuidValue.fromString('00000000-0000-0000-0000-000000000001');

DateTime day(int month, int dayOfMonth) =>
    DateTime.utc(2026, month, dayOfMonth);

DayLog dayLog(DateTime date, {FlowLevel? flow, String? note}) =>
    DayLog(userId: testUserId, date: date, flow: flow, note: note);

PeriodSpan period(DateTime start, {int days = 5}) => PeriodSpan(
  periodId: 1,
  startDate: start,
  endDate: start.add(Duration(days: days - 1)),
  endConfirmed: false,
);

PainEntry pain(DateTime date, {int level = 5}) => PainEntry(
  userId: testUserId,
  date: date,
  timestamp: date.add(const Duration(hours: 9)),
  loggedAt: date.add(const Duration(hours: 9)),
  level: level,
  locations: const [PainLocation.cramps],
);

Medication medication(int id, String name) => Medication(
  id: id,
  userId: testUserId,
  name: name,
  usualDose: '200 mg',
);

MedicationReminder reminder(int id, int medicationId, {bool isDue = true}) =>
    MedicationReminder(
      id: id,
      userId: testUserId,
      medicationId: medicationId,
      dueAt: DateTime.utc(2026, 10, 3, 12),
      isDue: isDue,
    );

Prediction prediction({
  DateTime? nextPeriodStart,
  DateTime? predictedPeriodEnd,
  DateTime? fertileWindowStart,
  DateTime? fertileWindowEnd,
}) => Prediction(
  confidenceDays: 2,
  nextPeriodStart: nextPeriodStart,
  predictedPeriodEnd: predictedPeriodEnd,
  fertileWindowStart: fertileWindowStart,
  fertileWindowEnd: fertileWindowEnd,
);

PeriodChange periodChange(PeriodChangeKind kind, int days) =>
    PeriodChange(kind: kind, lengthDays: days);
