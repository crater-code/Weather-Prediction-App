// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Professional NGO Color Palette
  // Base colors: neutral greys / slate / off-white
  static const Color background = Color(0xFFFAFAFA); // Off-white background
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light grey variant
  
  // Navigation and informational (Blue)
  static const Color primary = Color(0xFF1976D2); // Professional blue for navigation
  static const Color primaryContainer = Color(0xFFE3F2FD); // Light blue container
  
  // Semantic colors
  static const Color success = Color(0xFF2E7D32); // Green for resolved/success
  static const Color successContainer = Color(0xFFE8F5E8); // Light green container
  static const Color warning = Color(0xFFF57C00); // Amber/Orange for in-progress/warning
  static const Color warningContainer = Color(0xFFFFF3E0); // Light orange container
  static const Color error = Color(0xFFD32F2F); // Red for high severity/danger
  static const Color errorContainer = Color(0xFFFFEBEE); // Light red container
  
  // Neutral colors (Professional greys)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
  
  // Text colors
  static const Color onBackground = Color(0xFF212121); // Dark text on light background
  static const Color onSurface = Color(0xFF212121); // Dark text on white surface
  static const Color onSurfaceVariant = Color(0xFF616161); // Medium text
  static const Color outline = Color(0xFFE0E0E0); // Borders and dividers
  
  // Legacy color aliases for backward compatibility
  static const Color accent = warning; // Alias for warning color
  static const Color info = primary; // Alias for primary color
  static const Color slate50 = neutral50;
  static const Color slate100 = neutral100;
  static const Color slate200 = neutral200;
  static const Color slate300 = neutral300;
  static const Color slate400 = neutral400;
  static const Color slate500 = neutral500;
  static const Color slate600 = neutral600;
  static const Color slate700 = neutral700;
  static const Color slate800 = neutral800;
  static const Color slate900 = neutral900;
  
  static const double cardRadius = 16.0;

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      secondary: warning,
      secondaryContainer: warningContainer,
      tertiary: success,
      tertiaryContainer: successContainer,
      error: error,
      errorContainer: errorContainer,
      surface: surface,
      surfaceVariant: surfaceVariant,
      background: background,
      onBackground: onBackground,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Display', // iOS-style font fallback
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: onBackground,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: onBackground,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: onBackground,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: onBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: onBackground,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: onBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: onSurfaceVariant,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: onSurfaceVariant,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: neutral600,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: neutral600,
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: slate900,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onBackground,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
        margin: EdgeInsets.zero,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: slate300, width: 1),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      iconTheme: base.iconTheme.copyWith(
        color: neutral600,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
