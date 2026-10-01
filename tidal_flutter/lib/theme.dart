import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// All of Tidal's colors in one place, matching the design system in
/// CLAUDE.md. Pull colors from here instead of hard-coding hex values in
/// screens, so the whole app stays visually consistent.
class TidalColors {
  TidalColors._();

  static const background = Color(0xFFFAF7FD);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE7E0F0);

  static const text = Color(0xFF2E2640);
  static const textSecondary = Color(0xFF655D78);

  // Lavender: the primary color. Buttons, titles, the active tab.
  static const lavender = Color(0xFF6B4FA0);
  static const lavenderCircle = Color(0xFF7A5CB8);
  static const lavenderRing = Color(0xFFDCD0F3);
  static const lavenderBand = Color(0xFFEDE6F9);

  // Yellow: the secondary color. The "+" button and mood.
  static const yellow = Color(0xFFFFD95E);
  static const yellowBand = Color(0xFFFFF4CC);
  static const yellowIcon = Color(0xFF8A6500);

  // Rose: reserved for period and pain only, never used elsewhere.
  static const rose = Color(0xFFB04A68);
  static const roseBand = Color(0xFFFCE8EE);

  // Used for disabled/"coming soon" tiles, not part of the core palette.
  static const disabled = Color(0xFFF1EDF7);
  static const disabledIcon = Color(0xFFB7AFC9);
}

/// Shared corner radii. CLAUDE.md calls for 14-20px rounded corners.
class TidalRadius {
  TidalRadius._();

  static const small = 14.0;
  static const large = 20.0;
}

/// Builds the single theme used throughout the app.
ThemeData buildTidalTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: TidalColors.background,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: TidalColors.lavender,
          brightness: Brightness.light,
        ).copyWith(
          primary: TidalColors.lavender,
          secondary: TidalColors.yellow,
          surface: TidalColors.card,
          onSurface: TidalColors.text,
        ),
  );

  final textTheme = GoogleFonts.nunitoSansTextTheme(base.textTheme).copyWith(
    // Fraunces is used for titles and big numbers.
    headlineLarge: GoogleFonts.fraunces(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: TidalColors.text,
    ),
    headlineMedium: GoogleFonts.fraunces(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: TidalColors.text,
    ),
    titleLarge: GoogleFonts.fraunces(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: TidalColors.text,
    ),
    // Nunito Sans is used for everything else.
    bodyLarge: GoogleFonts.nunitoSans(fontSize: 16, color: TidalColors.text),
    bodyMedium: GoogleFonts.nunitoSans(
      fontSize: 14,
      color: TidalColors.textSecondary,
    ),
    labelLarge: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: TidalColors.background,
      foregroundColor: TidalColors.text,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: TidalColors.lavender,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TidalColors.card,
      indicatorColor: TidalColors.lavenderBand,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.nunitoSans(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? TidalColors.lavender : TidalColors.textSecondary,
        );
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TidalColors.lavender,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TidalRadius.large),
        ),
        textStyle: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: TidalColors.yellow,
      foregroundColor: TidalColors.lavender,
    ),
  );
}
