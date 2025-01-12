import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData createDefaultTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    fontFamily: 'MPLUSRounded1c-Regular',
    textTheme: TextTheme(
      bodyLarge: const TextStyle(fontFamily: 'MPLUSRounded1c-Medium'),
      bodyMedium: TextStyle(
        fontFamily: 'MPLUSRounded1c-Medium',
        fontSize: 16.sp,
      ),
    ),
  );
}
