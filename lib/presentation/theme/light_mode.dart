import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData createLightMode() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    fontFamily: 'MPLUSRounded1c-Regular',
    appBarTheme: AppBarTheme(toolbarHeight: 56.r),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 20.sp),
      bodyMedium: TextStyle(fontSize: 16.sp),
      bodySmall: TextStyle(fontSize: 14.sp),
      labelLarge: TextStyle(fontSize: 16.sp),
      labelMedium: TextStyle(fontSize: 14.sp),
      labelSmall: TextStyle(fontSize: 12.sp),
    ),
  );
}
