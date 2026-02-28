import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {

    const Color mainColor = Color(0xFFF48FB1);

    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: mainColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      );

    return ThemeData(

      useMaterial3: true,

      colorScheme: baseColorScheme,

      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

        scaffoldBackgroundColor: isDarkTheme
            ? const Color(0xFF181818)
            : Colors.white,

        cardColor: isDarkTheme 
            ? const Color(0xFF242424)
            : Colors.white,
        
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
          backgroundColor: isDarkTheme
              ? const Color(0xFF181818)
              : Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: isDarkTheme
            ? const Color(0xFF181818)
            : Colors.white,

            selectedItemColor: mainColor,
            unselectedItemColor: Colors.grey,

            selectedIconTheme: const IconThemeData(size: 26),
            unselectedIconTheme: const IconThemeData(size: 22),

            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDarkTheme
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFFCE4EC),

          contentPadding: const EdgeInsets.all(14),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(14),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: mainColor,
            ),
            borderRadius: BorderRadius.circular(14),
          ),

          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(14),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: baseColorScheme.error,
            ),
            borderRadius: BorderRadius.circular(14),
          ),

        
        ));
  }
}