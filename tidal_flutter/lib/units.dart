import 'package:tidal_client/tidal_client.dart';

/// Converting stored values (always kg and °C) to and from the units the
/// user picked with the Weight and Temperature sheets' switches.

double kgTo(WeightUnit unit, double kg) =>
    unit == WeightUnit.lb ? kg * 2.20462 : kg;

double kgFrom(WeightUnit unit, double value) =>
    unit == WeightUnit.lb ? value / 2.20462 : value;

double celsiusTo(TemperatureUnit unit, double celsius) =>
    unit == TemperatureUnit.fahrenheit ? celsius * 9 / 5 + 32 : celsius;

double celsiusFrom(TemperatureUnit unit, double value) =>
    unit == TemperatureUnit.fahrenheit ? (value - 32) * 5 / 9 : value;

String weightSymbol(WeightUnit unit) => unit == WeightUnit.lb ? 'lb' : 'kg';

String temperatureSymbol(TemperatureUnit unit) =>
    unit == TemperatureUnit.fahrenheit ? '°F' : '°C';

/// One decimal place, without a trailing ".0" (e.g. "62.5", "63").
String formatOneDecimal(double value) {
  final rounded = (value * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? rounded.toStringAsFixed(0)
      : rounded.toStringAsFixed(1);
}

/// kg and °C, used until the user's choice has loaded.
final defaultUnits = UnitPreferences(
  weightUnit: WeightUnit.kg,
  temperatureUnit: TemperatureUnit.celsius,
);
