import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData createDarkMode() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'MPLUSRounded1c-Regular',
    appBarTheme: AppBarTheme(
      toolbarHeight: 56.r,
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 34.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 20.sp,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.blueGrey,
    ),
    cardTheme: CardTheme(
      color: Colors.blueGrey,
      elevation: 2.r,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    ),
  );
}
