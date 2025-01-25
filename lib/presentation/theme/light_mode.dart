import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData createLightMode() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    fontFamily: 'MPLUSRounded1c-Regular',
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontSize: 16.sp,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'MPLUSRounded1c-Medium',
        fontSize: 20.sp,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'MPLUSRounded1c-Medium',
      ),
    ),
  );
}
