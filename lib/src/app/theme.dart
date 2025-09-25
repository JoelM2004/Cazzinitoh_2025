import 'package:flutter/material.dart';

// Definición de paleta de colores (light y dark)
class AppColors {
  // Light theme
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF232323); // oklch(0.145 0 0)
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF232323);
  static const popover = Color(0xFFFFFFFF);
  static const popoverForeground = Color(0xFF232323);
  static const primary = Color(0xFF030213);
  static const primaryForeground = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFF2F2FA); // aproximado de oklch(0.95…)
  static const secondaryForeground = Color(0xFF030213);
  static const muted = Color(0xFFECECF0);
  static const mutedForeground = Color(0xFF717182);
  static const accent = Color(0xFFE9EBEF);
  static const accentForeground = Color(0xFF030213);
  static const destructive = Color(0xFFD4183D);
  static const destructiveForeground = Color(0xFFFFFFFF);
  static const border = Color.fromRGBO(0, 0, 0, 0.1);
  static const inputBackground = Color(0xFFF3F3F5);
  static const switchBackground = Color(0xFFCBced4);

  // Dark theme
  static const darkBackground = Color(0xFF232323);
  static const darkForeground = Color(0xFFFFFFFF);
  static const darkCard = Color(0xFF232323);
  static const darkCardForeground = Color(0xFFFFFFFF);
  static const darkPopover = Color(0xFF232323);
  static const darkPopoverForeground = Color(0xFFFFFFFF);
  static const darkPrimary = Color(0xFFFFFFFF);
  static const darkPrimaryForeground = Color(0xFF333333);
  static const darkSecondary = Color(0xFF444444);
  static const darkSecondaryForeground = Color(0xFFFFFFFF);
  static const darkMuted = Color(0xFF444444);
  static const darkMutedForeground = Color(0xFFB4B4B4);
  static const darkAccent = Color(0xFF444444);
  static const darkAccentForeground = Color(0xFFFFFFFF);
  static const darkDestructive = Color(0xFF8C2B2B);
  static const darkDestructiveForeground = Color(0xFFA65353);
  static const darkBorder = Color(0xFF444444);
  static const darkInput = Color(0xFF444444);
}

// Tipografía base
class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const p = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}

// ThemeData con light y dark
class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    primaryColor: AppColors.primary,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineLarge: AppTextStyles.h4,
      bodyLarge: AppTextStyles.p,
      bodyMedium: AppTextStyles.p,
      labelLarge: AppTextStyles.button,
      titleMedium: AppTextStyles.label,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      border: OutlineInputBorder(),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.darkPrimary,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineLarge: AppTextStyles.h4,
      bodyLarge: AppTextStyles.p,
      bodyMedium: AppTextStyles.p,
      labelLarge: AppTextStyles.button,
      titleMedium: AppTextStyles.label,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput,
      border: OutlineInputBorder(),
    ),
  );
}
