import 'package:flutter/material.dart';

ThemeData createTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    fontFamily: 'MPLUSRounded1c-Regular',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'MPLUSRounded1c-Medium'),
    ),
  );
}
