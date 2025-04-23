// 
// primary: اللون الرئيسي، يستخدم كخلفية للأزرار والعناصر الرئيسية.
// onPrimary: اللون المستخدم للنصوص أو العناصر فوق اللون الرئيسي.
// secondary: لون ثانوي، يمكن استخدامه لأغراض مختلفة.
// 

import 'package:flutter/material.dart';

extension CustomThemeColors on ThemeData {
  Color get gradientStart => colorScheme.primary;
  Color get gradientEnd => colorScheme.secondary;
  Color get textFieldFill => colorScheme.surface;
  Color get buttonTextColor => colorScheme.onPrimary;
  Color get onSecondaryFixed => colorScheme.onSecondaryFixed;
}

abstract class ThemeManager {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    primaryColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE53935),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE53935),
      onPrimary: Colors.white,
      secondary: Color(0xFFEF9A9A),
      surface: Color(0xFFF1F1F1),
      onSecondaryFixed: Color.fromARGB(255, 224, 224, 224),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE53935),
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        color: Colors.black54,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE53935),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFE53935)),
  );

  //   static ThemeData darkTheme = ThemeData(
  //     useMaterial3: true,
  //     scaffoldBackgroundColor: const Color(0xFF212121),
  //     primaryColor: const Color(0xFFB71C1C),
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: Color(0xFFB71C1C),
  //       foregroundColor: Colors.white,
  //     ),
  //     colorScheme: const ColorScheme.dark(
  //       primary: Color(0xFFEF5350),
  //       // primary: Color(0xFFFFCDD2),
  //       onPrimary: Colors.white,
  //       // secondary: Color(0xFFB71C1C),
  //       secondary: Color(0xFFFFCDD2),
  //       surface: Color(0xFF424242),
  //       onSecondaryFixed: Color.fromARGB(255, 224, 224, 224),
  //     ),
  //     textTheme: const TextTheme(
  //       displayLarge: TextStyle(
  //         fontSize: 50,
  //         fontWeight: FontWeight.bold,
  //         color: Color(0xFFFFCDD2),
  //       ),
  //       headlineSmall: TextStyle(
  //         fontSize: 12,
  //         color: Colors.white70,
  //         fontWeight: FontWeight.w300,
  //         fontStyle: FontStyle.italic,
  //       ),
  //       bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
  //       labelLarge: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: const Color(0xFF424242),
  //       hintStyle: const TextStyle(color: Colors.white70),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(15),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFFEF5350),
  //         foregroundColor: Colors.white,
  //         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       ),
  //     ),
  //     drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF880E4F)),
  //   );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 30, 29, 41),
    primaryColor: const Color(0xFFE57373), // Soft red tone
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 30, 29, 41),
      foregroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 233, 83, 83), // Warm red
      onPrimary: Colors.white,
      secondary: Color(0xFFE57373), // Soft purple accent
      surface: Color.fromARGB(255, 38, 37, 53), // Background cards, fields
      onSecondaryFixed: Color.fromARGB(255, 143, 142, 142), // Divider color or contrast fill
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE57373),
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        color: Colors.white60,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 30, 29, 41),
      hintStyle: TextStyle(color: Colors.white54),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE57373),
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1A1A1A)),
  );
}
