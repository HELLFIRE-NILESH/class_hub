import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();

  static const Color primaryColor = Color(0xFF193238);
  static const Color backgroundColor = Color(0xFFF6F8F9);
  static const Color accentColor = Color(0xFF193238);
  static const Color buttonColor = Color(0xFFEDEDF2);
  static const Color buttonHoverColor = Color(0xFFBDC3C7);

  static ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge:
        TextStyle(
          fontFamily: "Merri",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
          fontFamily: "Merri",
          color: Colors.white,
        fontWeight: FontWeight.bold
      ),
      bodyLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryColor
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Merri",
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
          color: Colors.grey[300]
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        wordSpacing: 2,

      )

    ),

    appBarTheme: const AppBarTheme(
      elevation: 0, // Increased elevation for more depth
      centerTitle: true,
      backgroundColor: backgroundColor,
      titleSpacing: 2,

      titleTextStyle: TextStyle(
        fontFamily: "Merri",
        fontSize: 24, // Slightly larger font size
        fontWeight: FontWeight.bold, // Added weight for emphasis
        color: primaryColor,
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
    ),

    scaffoldBackgroundColor: backgroundColor,
    cardColor: Colors.white,

    // Primary color scheme
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: primaryColor,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color on button
        backgroundColor: primaryColor, // Button background color
        textStyle: const TextStyle(
          fontFamily: "Merri",
          fontSize: 14,
          fontWeight: FontWeight.bold, // Bold text for emphasis
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Increased padding
        elevation: 8, // Increased elevation for better shadow effect
        shadowColor: primaryColor.withOpacity(0.3), // Shadow color
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        textStyle: const TextStyle(
          fontFamily: "Merri",
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontFamily: "Merri",
          fontSize: 16,

        ),
      ),
    ),

    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: primaryColor.withValues(alpha: 0.6 ),
      thickness: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      filled: true,
      fillColor: const Color(0xFFECECEC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Increased border radius
        borderSide: const BorderSide(color: Color(0xFFECECEC)), // Set border color to white
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Increased border radius
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Increased border radius
        borderSide: BorderSide(color: const Color(0xFFECECEC).withOpacity(0.5)), // Set border color to white
      ),
      labelStyle: TextStyle(
        color: primaryColor.withOpacity(0.8),
        fontSize: 17,
        fontFamily: "Merri",

      ),


      hintStyle: TextStyle(
        color: primaryColor.withOpacity(0.5),
        fontFamily: "Merri",
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF193238),
      contentTextStyle: TextStyle(
        fontSize: 18,
        fontFamily: "Merri",
        color: Colors.white
      )
    ),

    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: primaryColor.withOpacity(0.5),
      labelStyle: const TextStyle(
        fontFamily: "Merri",
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),

    // Additional themes for enhanced usability and aesthetics
    cardTheme: CardTheme(

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
    ),

    // Elevated Button Hover Effects
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      hoverColor: buttonHoverColor,
    ),
  );
}
