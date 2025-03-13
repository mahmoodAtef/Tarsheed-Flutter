import 'package:flutter/material.dart';

class ThemeManager {
  static const Color primaryColor = Color(0xFF2D68FF);
  static const Color backgroundColor = Colors.white;
  static const Color secondaryBackgroundColor = Color(0xFFF5F7FF);
  static const Color textColor = Colors.black;
  static const Color secondaryTextColor = Color(0xFF6E7191);
  static const Color dividerColor = Color(0xFFEAECF0);
  static const Color errorColor = Color(0xFFe81c1c);

  static ThemeData appTheme() {
    return ThemeData(
      // General theme properties
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryBackgroundColor,
        surface: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: textColor,
        onSurface: textColor,
        onError: Colors.white,
      ),

      // Text theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: secondaryTextColor,
        ),
      ),

      // Input decoration theme (for text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBackgroundColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        suffixIconColor: secondaryTextColor,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: secondaryBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        iconTheme: IconThemeData(
          color: textColor,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
