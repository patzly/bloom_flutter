import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/controller/bloom_controller_impl.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/home_screen.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
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

    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );

    _controller = BloomControllerImpl(
      navigationService: NavigationServiceImpl(_router),
      phoneTimeService: PhoneTimeService(),
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
                titleLarge: TextStyle(fontWeight: FontWeight.bold),
                headlineSmall: TextStyle(fontWeight: FontWeight.bold),
              );

              final defaultLightColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.green,
                contrastLevel: 0,
              );
              final themeDataLight = ThemeData(
                fontFamily: 'Quicksand',
                textTheme: textTheme,
                // optional: use lightColorScheme for dynamic color
                colorScheme: defaultLightColorScheme.harmonized(),
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
                contrastLevel: 0,
              );
              final themeDataDark = ThemeData(
                fontFamily: 'Quicksand',
                textTheme: textTheme,
                // optional: use darkColorScheme for dynamic color
                colorScheme: defaultDarkColorScheme.harmonized(),
                iconTheme: const IconThemeData(opticalSize: 24, grade: -25),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android:
                        PredictiveBackPageTransitionsBuilder(),
                  },
                ),
              );

              return MaterialApp.router(
                title: 'Bloom',
                routerConfig: _router,
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
