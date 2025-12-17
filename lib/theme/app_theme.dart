import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// App Theme System
/// Provides consistent HUD-style theming with retro monospace typography
/// IMPROVED: Better mobile readability with larger font sizes and better contrast
class AppTheme {
  /// THEME CONFIGURATION
  /// Get complete MaterialApp theme
  static ThemeData getTheme(ColorTheme colorTheme) {
    return ThemeData(
      // Background
      scaffoldBackgroundColor: kHudBackground,

      // Primary colors
      primaryColor: colorTheme.primary,
      colorScheme: ColorScheme.dark(
        primary: colorTheme.primary,
        secondary: colorTheme.accent,
        error: colorTheme.alert,
        surface: kHudBackground,
      ),

      // Typography - Retro Monospace with IMPROVED readability
      fontFamily: 'Courier',
      textTheme: TextTheme(
        // Display styles - Large headers
        displayLarge: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 36, // Increased from 32
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
        displayMedium: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 32, // Increased from 28
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        displaySmall: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 28, // Increased from 24
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),

        // Headline styles - Section headers
        headlineLarge: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 24, // Increased from 20
          fontWeight: FontWeight.w700, // Increased weight for better visibility
        ),
        headlineMedium: getHudTextStyle(
          color: Colors.white,
          fontSize: 20, // Increased from 18
          fontWeight: FontWeight.w700, // Increased weight
        ),
        headlineSmall: getHudTextStyle(
          color: Colors.white,
          fontSize: 18, // Increased from 16
          fontWeight: FontWeight.w600,
        ),

        // Title styles - Card headers and important text
        titleLarge: getHudTextStyle(
          color: colorTheme.accent,
          fontSize: 20, // Increased from 18
          fontWeight: FontWeight.w700, // Increased weight
        ),
        titleMedium: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 18, // Increased from 16
          fontWeight: FontWeight.w600,
        ),
        titleSmall: getHudTextStyle(
          color: Colors.white,
          fontSize: 16, // Increased from 14
          fontWeight: FontWeight.w600,
        ),

        // Body styles - Main content
        bodyLarge: getHudTextStyle(
          color: Colors.white,
          fontSize: 18, // Increased from 16
          lineHeight: 1.5, // Better readability
        ),
        bodyMedium: getHudTextStyle(
          color: Colors.white,
          fontSize: 16, // Increased from 14
          lineHeight: 1.5,
        ),
        bodySmall: getHudTextStyle(
          color: Colors.white.withOpacity(0.85), // Better contrast than white70
          fontSize: 14, // Increased from 12
          lineHeight: 1.4,
        ),

        // Label styles - Small UI elements
        labelLarge: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 15, // Increased from 16 for better balance
          fontWeight: FontWeight.w700, // Increased weight
        ),
        labelMedium: getHudTextStyle(
          color: Colors.white,
          fontSize: 13, // Increased from 14 for better visibility
          fontWeight: FontWeight.w700, // Increased weight
        ),
        labelSmall: getHudTextStyle(
          color: Colors.white.withOpacity(0.8), // Better contrast
          fontSize: 11, // Increased from 12
          fontWeight: FontWeight.w600, // Increased weight
          letterSpacing: 0.8, // Added for clarity
        ),
      ),

      // Component themes
      appBarTheme: AppBarTheme(
        backgroundColor: kHudBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorTheme.primary, size: 28), // Larger icons
        titleTextStyle: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 22, // Increased from 20
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorTheme.primary,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 16, // Explicit size
            fontWeight: FontWeight.w700, // Heavier weight
            letterSpacing: 1.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // More padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorTheme.primary,
          side: BorderSide(color: colorTheme.primary, width: 2),
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 16, // Explicit size
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorTheme.primary,
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorTheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorTheme.primary.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorTheme.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 16, // Increased from 14
        ),
        hintStyle: getHudTextStyle(
          color: Colors.grey,
          fontSize: 16, // Increased from 14
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // More padding
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: kHudBackground.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorTheme.primary.withValues(alpha: 0.3)),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: kHudBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorTheme.primary.withValues(alpha: 0.5)),
        ),
        titleTextStyle: getHudTextStyle(
          color: colorTheme.primary,
          fontSize: 20, // Increased from 18
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: getHudTextStyle(
          color: Colors.white,
          fontSize: 16, // Increased from 14
          lineHeight: 1.5,
        ),
      ),

      // Icon theme - Larger icons for mobile
      iconTheme: IconThemeData(color: colorTheme.primary, size: 24),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorTheme.primary.withValues(alpha: 0.3),
        thickness: 1,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return colorTheme.primary;
            }
            return Colors.grey;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return colorTheme.primary.withValues(alpha: 0.5);
            }
            return Colors.grey.withValues(alpha: 0.3);
          },
        ),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return colorTheme.primary;
            }
            return Colors.transparent;
          },
        ),
        checkColor: WidgetStateProperty.all(Colors.black),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return colorTheme.primary;
            }
            return Colors.grey;
          },
        ),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorTheme.primary,
        inactiveTrackColor: colorTheme.primary.withValues(alpha: 0.3),
        thumbColor: colorTheme.primary,
        overlayColor: colorTheme.primary.withValues(alpha: 0.3),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorTheme.primary,
        circularTrackColor: colorTheme.primary.withValues(alpha: 0.3),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kHudBackground.withValues(alpha: 0.95),
        contentTextStyle: getHudTextStyle(
          color: Colors.white,
          fontSize: 16, // Increased from 14
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorTheme.primary.withValues(alpha: 0.5)),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kHudBackground,
        selectedItemColor: colorTheme.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 13, // Increased from 12
          fontWeight: FontWeight.w700, // Heavier weight
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 12, // Increased from 11
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 28), // Larger selected icons
        unselectedIconTheme: const IconThemeData(size: 24),
      ),

      // ListTile theme
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: colorTheme.primary,
        titleTextStyle: getHudTextStyle(
          color: Colors.white,
          fontSize: 16, // Increased from 14
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: getHudTextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14, // Increased from 12
        ),
      ),
    );
  }

  /// TEXT STYLES
  /// Get HUD-styled text with retro monospace font and glow effect
  /// IMPROVED: Added lineHeight parameter for better readability
  static TextStyle getHudTextStyle({
    required Color color,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0.5,
    double? lineHeight, // NEW: Optional line height
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Courier',
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: lineHeight, // Line height for better readability
      shadows: [
        Shadow(
          blurRadius: 3.0,
          color: color.withValues(alpha: 0.8),
        ),
        Shadow(
          blurRadius: 10.0,
          color: color.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  /// BOX DECORATIONS
  /// Get HUD-styled container decoration with glow effect
  static BoxDecoration getHudBoxDecoration({
    required Color borderColor,
    required Color shadowColor,
  }) {
    return BoxDecoration(
      color: kHudBackground.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: borderColor.withValues(alpha: 0.7),
        width: 2.0,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.3),
          blurRadius: 15.0,
          spreadRadius: 2.0,
        ),
      ],
    );
  }

  /// Get simple border decoration
  static BoxDecoration getSimpleBorder({
    required Color color,
    double width = 1.0,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: color.withValues(alpha: 0.5),
        width: width,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  /// Get gradient background decoration
  static BoxDecoration getGradientBackground({
    required Color startColor,
    required Color endColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          startColor.withValues(alpha: 0.1),
          endColor.withValues(alpha: 0.05),
          kHudBackground,
        ],
      ),
    );
  }

  /// CATEGORY COLORS
  /// Get color for news category
  static Color getCategoryColor(String category, ColorTheme theme) {
    switch (category.toUpperCase()) {
      case 'ALERT':
        return theme.alert;
      case 'BUSINESS':
        return Colors.lightGreenAccent;
      case 'TECHNOLOGY':
        return theme.primary;
      case 'SPORTS':
        return Colors.deepOrangeAccent;
      case 'POLITICS':
        return Colors.deepPurpleAccent;
      case 'GENERAL':
      default:
        return theme.accent.withValues(alpha: 0.8);
    }
  }

  /// SHADOWS
  /// Get glow shadow effect
  static List<BoxShadow> getGlowShadow({
    required Color color,
    double blurRadius = 15.0,
    double spreadRadius = 2.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.2),
        blurRadius: blurRadius * 2,
        spreadRadius: spreadRadius * 2,
      ),
    ];
  }

  /// Get text glow effect
  static List<Shadow> getTextGlow({required Color color}) {
    return [
      Shadow(
        blurRadius: 3.0,
        color: color.withValues(alpha: 0.8),
      ),
      Shadow(
        blurRadius: 10.0,
        color: color.withValues(alpha: 0.4),
      ),
      Shadow(
        blurRadius: 20.0,
        color: color.withValues(alpha: 0.2),
      ),
    ];
  }

  /// GRADIENTS
  /// Get neon gradient
  static LinearGradient getNeonGradient({required Color color}) {
    return LinearGradient(
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0.0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Get radial glow gradient
  static RadialGradient getRadialGlow({required Color color}) {
    return RadialGradient(
      colors: [
        color.withValues(alpha: 0.4),
        color.withValues(alpha: 0.2),
        color.withValues(alpha: 0.0),
      ],
    );
  }

  /// UTILITY METHODS
  /// Get opacity value from percentage
  static double getOpacity(int percentage) {
    return (percentage / 100).clamp(0.0, 1.0);
  }

  /// Lighten color
  static Color lightenColor(Color color, {double amount = 0.1}) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// Darken color
  static Color darkenColor(Color color, {double amount = 0.1}) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}