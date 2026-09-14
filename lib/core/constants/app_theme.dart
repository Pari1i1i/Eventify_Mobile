import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    final textTheme = GoogleFonts.spaceGroteskTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.textBorder,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.textBorder,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textBorder,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textBorder,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textBorder,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textBorder,
      ),
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textBorder,
        letterSpacing: 0.5,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purpleSeed,
        primary: AppColors.yellow,
        secondary: AppColors.teal,
        surface: AppColors.surface,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AppColors.textBorder,
          letterSpacing: 1.0,
        ),
        iconTheme: const IconThemeData(color: AppColors.textBorder),
      ),
    );
  }
}
