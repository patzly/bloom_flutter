import 'package:bloom_flutter/constants.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class BloomTheme {
  static TextTheme get _textTheme =>
      const TextTheme(labelLarge: TextStyle(fontWeight: FontWeight.bold));

  static ColorScheme _defaultLightColorScheme(ContrastLevel level) =>
      ColorScheme.fromSeed(
        seedColor: Colors.green,
        contrastLevel: _contrastLevelFrom(level),
      );

  static ColorScheme _defaultDarkColorScheme(ContrastLevel level) =>
      ColorScheme.fromSeed(
        seedColor: Colors.green,
        contrastLevel: _contrastLevelFrom(level),
        brightness: Brightness.dark,
      );

  static double _contrastLevelFrom(ContrastLevel level) => switch (level) {
    ContrastLevel.standard => 0.0,
    ContrastLevel.medium => 0.5,
    ContrastLevel.high => 1.0,
  };

  static ThemeData lightTheme({
    required ColorScheme? dynamicScheme,
    required bool useDynamicColors,
    required ContrastLevel contrastLevel,
  }) => ThemeData(
    fontFamily: 'Nunito',
    textTheme: _textTheme,
    colorScheme:
        useDynamicColors
            ? dynamicScheme
            : _defaultLightColorScheme(contrastLevel).harmonized(),
    iconTheme: const IconThemeData(opticalSize: 24, grade: 0),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData darkTheme({
    required ColorScheme? dynamicScheme,
    required bool useDynamicColors,
    required ContrastLevel contrastLevel,
  }) => ThemeData(
    fontFamily: 'Nunito',
    textTheme: _textTheme,
    colorScheme:
        useDynamicColors
            ? dynamicScheme
            : _defaultDarkColorScheme(contrastLevel).harmonized(),
    iconTheme: const IconThemeData(opticalSize: 24, grade: -25),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  );
}
