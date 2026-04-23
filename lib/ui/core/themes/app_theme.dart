import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC94F7C),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFD8E5),
      onPrimaryContainer: Color(0xFF4C1028),
      secondary: Color(0xFF8D5D72),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFD9E6),
      onSecondaryContainer: Color(0xFF3B1726),
      tertiary: Color(0xFF5B765E),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFDDF4DD),
      onTertiaryContainer: Color(0xFF162B19),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surface: Color(0xFFFFFBFE),
      onSurface: Color(0xFF281D22),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFFF4F8),
      surfaceContainer: Color(0xFFFFEDF3),
      surfaceContainerHigh: Color(0xFFFFE7F0),
      surfaceContainerHighest: Color(0xFFFFDFEA),
      onSurfaceVariant: Color(0xFF6F5861),
      outline: Color(0xFF9D7B87),
      outlineVariant: Color(0xFFE9C5D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF3E3036),
      onInverseSurface: Color(0xFFFFECF2),
      inversePrimary: Color(0xFFFFB1CA),
      surfaceTint: Color(0xFFC94F7C),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFF7FA),
      textTheme: Typography.material2021().black.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: const Color(0xFFFFF7FA),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFF4C1028),
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFBFE),
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFF0B8CA)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE9C5D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC94F7C), width: 1.8),
        ),
        labelStyle: const TextStyle(color: Color(0xFF8D5D72)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(48, 44),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: const BorderSide(color: Color(0xFFDFA4B8)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(48, 44),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surface;
        }),
        checkColor: const WidgetStatePropertyAll(Color(0xFFFFFFFF)),
        side: const BorderSide(color: Color(0xFFDFA4B8), width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBFE),
          foregroundColor: colorScheme.secondary,
          selectedBackgroundColor: colorScheme.primaryContainer,
          selectedForegroundColor: colorScheme.onPrimaryContainer,
          side: const BorderSide(color: Color(0xFFE9C5D0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        contentTextStyle: const TextStyle(
          color: Color(0xFF4C1028),
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.primaryContainer,
        headerForegroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
