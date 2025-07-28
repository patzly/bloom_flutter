import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/controller/bloom_controller_impl.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/home_screen.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';
import 'package:bloom_flutter/services/foreground/foreground_service_impl.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
import 'package:bloom_flutter/services/time/time_service_impl.dart';
import 'package:bloom_flutter/routs/app_router.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BloomApp extends StatefulWidget {
  const BloomApp({super.key});

  @override
  State<BloomApp> createState() => _BloomAppState();
}

class _BloomAppState extends State<BloomApp> {
  late final GoRouter _router;
  late final BloomController _controller;

  @override
  void initState() {
    super.initState();

    _router = app_routs.createRouter();

    _controller = BloomControllerImpl(
      navigationService: NavigationServiceImpl(_router),
      foregroundService: ForegroundServiceImpl.create(TimeServiceImpl()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BloomController>.value(
      value: _controller,
      child: BlocBuilder<BloomController, BloomModel>(
        builder: (BuildContext context, BloomModel model) {
          return DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) {
              final textTheme = TextTheme(
                labelLarge: TextStyle(fontWeight: FontWeight.bold),
              );

              final contrastLevel = switch (model.contrastLevel) {
                ContrastLevel.standard => 0.0,
                ContrastLevel.medium => 0.5,
                ContrastLevel.high => 1.0,
              };

              final defaultLightColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.green,
                contrastLevel: contrastLevel,
              );
              final themeDataLight = ThemeData(
                fontFamily: 'Nunito',
                textTheme: textTheme,
                colorScheme:
                    model.useDynamicColors
                        ? lightColorScheme
                        : defaultLightColorScheme.harmonized(),
                iconTheme: const IconThemeData(opticalSize: 24, grade: 0),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android:
                        PredictiveBackPageTransitionsBuilder(),
                  },
                ),
              );

              final defaultDarkColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
                contrastLevel: contrastLevel,
              );
              final themeDataDark = ThemeData(
                fontFamily: 'Nunito',
                textTheme: textTheme,
                colorScheme:
                    model.useDynamicColors
                        ? darkColorScheme
                        : defaultDarkColorScheme.harmonized(),
                iconTheme: const IconThemeData(opticalSize: 24, grade: -25),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android:
                        PredictiveBackPageTransitionsBuilder(),
                  },
                ),
              );

              final themeMode = switch (model.brightnessLevel) {
                BrightnessLevel.auto => ThemeMode.system,
                BrightnessLevel.light => ThemeMode.light,
                BrightnessLevel.dark => ThemeMode.dark,
              };

              return MaterialApp.router(
                title: 'Bloom',
                routerConfig: _router,
                themeMode: themeMode,
                theme: themeDataLight,
                darkTheme: themeDataDark,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
