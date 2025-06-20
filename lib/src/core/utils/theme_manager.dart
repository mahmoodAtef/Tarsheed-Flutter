import 'package:flutter/material.dart';

class ThemeManager {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFF64B5F6);

  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color dangerRed = Color(0xFFE53935);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color cardBackground = Colors.black;
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color iconGray = Color(0xFF9E9E9E);
// Switch
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        primaryContainer: primaryBlueDark,
        secondary: successGreen,
        secondaryContainer: Color(0xFFE8F5E8),
        surface: surfaceColor,
        background: backgroundColor,
        error: dangerRed,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textLight,
        outline: dividerColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
          size: 24,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textLight,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: textHint,
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: iconGray,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 16,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryBlue,
        unselectedItemColor: iconGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: textLight,
        elevation: 6,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: primaryBlue,
        labelStyle: const TextStyle(
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 14,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(
          color: textLight,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return textLight;
          }
          return iconGray;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return dividerColor;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: dividerColor,
        circularTrackColor: dividerColor,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryBlue,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryBlue,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

// dark theme colors Switch
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);

// Dark Theme Text Colors
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF616161);

  static const Color dividerColorDark = Color(0xFF404040);

  static const Color iconGrayDark = Color(0xFF9E9E9E);
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        primaryContainer: primaryBlueDark,
        secondary: successGreen,
        secondaryContainer: Color(0xFF2E7D32),
        surface: surfaceColorDark,
        background: backgroundColorDark,
        error: dangerRed,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textPrimaryDark,
        onBackground: textPrimaryDark,
        onError: textLight,
        outline: dividerColorDark,
      ),
      scaffoldBackgroundColor: backgroundColorDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: textPrimaryDark,
          size: 24,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryDark,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryDark,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textLight,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlueLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlueLight,
          side: const BorderSide(color: primaryBlueLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColorDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColorDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: textHintDark,
        ),
        labelStyle: const TextStyle(
          color: textSecondaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackgroundDark,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: iconGrayDark,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColorDark,
        thickness: 1,
        space: 16,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColorDark,
        selectedItemColor: primaryBlue,
        unselectedItemColor: iconGrayDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: textLight,
        elevation: 8,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBackgroundDark,
        selectedColor: primaryBlue,
        labelStyle: const TextStyle(
          color: textPrimaryDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColorDark,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimaryDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: textPrimaryDark,
          fontSize: 14,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardBackgroundDark,
        contentTextStyle: const TextStyle(
          color: textPrimaryDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return textLight;
          }
          return iconGray;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return dividerColorDark;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: dividerColorDark,
        circularTrackColor: dividerColorDark,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryBlue,
        unselectedLabelColor: textSecondaryDark,
        indicatorColor: primaryBlue,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  static const Map<String, Color> statusColors = {
    'low': successGreen,
    'medium': warningOrange,
    'high': dangerRed,
    'active': primaryBlue,
    'inactive': iconGray,
  };

  static const TextStyle loginTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  static const TextStyle welcomeText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle deviceTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textLight,
  );

  static const TextStyle deviceSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textLight,
  );

  static const TextStyle statusText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );
}
