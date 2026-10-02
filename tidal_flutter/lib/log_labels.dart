import 'package:tidal_client/tidal_client.dart';

/// Display name for each [FlowLevel], shown inside the day circle (e.g.
/// "Period · Day 2" then "Heavy").
extension FlowLevelLabel on FlowLevel {
  String get label => switch (this) {
    FlowLevel.none => 'None',
    FlowLevel.light => 'Light',
    FlowLevel.medium => 'Medium',
    FlowLevel.heavy => 'Heavy',
  };
}

/// Display name and a short, friendly subtitle for each [Mood].
extension MoodLabel on Mood {
  String get label => switch (this) {
    Mood.happy => 'Happy',
    Mood.calm => 'Calm',
    Mood.tired => 'Tired',
    Mood.irritated => 'Irritated',
    Mood.sad => 'Sad',
    Mood.anxious => 'Anxious',
  };

  String get subtitle => switch (this) {
    Mood.happy => 'feeling good',
    Mood.calm => 'steady',
    Mood.tired => 'a bit low',
    Mood.irritated => 'on edge',
    Mood.sad => 'down',
    Mood.anxious => 'worried',
  };
}

/// Display text for each [PainLocation], used in chips and summary bands.
extension PainLocationLabel on PainLocation {
  String get label => switch (this) {
    PainLocation.cramps => 'Cramps',
    PainLocation.lowerBack => 'Lower back',
    PainLocation.head => 'Head',
    PainLocation.legs => 'Legs',
    PainLocation.stomach => 'Stomach',
  };
}

/// Joins pain locations into a short summary, e.g. "cramps, lower back".
String formatPainLocations(List<PainLocation> locations) {
  return locations.map((l) => l.label.toLowerCase()).join(', ');
}

/// Display name for each [MedicationType], shown as chips when adding a
/// medication.
extension MedicationTypeLabel on MedicationType {
  String get label => switch (this) {
    MedicationType.painkiller => 'Painkiller',
    MedicationType.birthControl => 'Birth control',
    MedicationType.vitamin => 'Vitamin / supplement',
    MedicationType.other => 'Other',
  };
}
