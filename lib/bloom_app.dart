import 'package:bloom_flutter/navigation/router.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class BloomApp extends StatelessWidget {
  const BloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      final defaultLightColorScheme = ColorScheme.fromSwatch(
          primarySwatch: Colors.green
      );
      final defaultDarkColorScheme = ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          brightness: Brightness.dark
      );

      return MaterialApp.router(
        title: 'Bloom',
        routerConfig: router,
        theme: ThemeData(
          colorScheme: lightColorScheme ?? defaultLightColorScheme,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            },
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? defaultDarkColorScheme,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}