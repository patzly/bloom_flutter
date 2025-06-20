import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/controller/bloom_controller_impl.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/home_screen.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BloomApp extends StatelessWidget {
  const BloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );

    return BlocProvider<BloomController>(
      create:
          (BuildContext context) => BloomControllerImpl(
            navigationService: NavigationServiceImpl(routerConfig),
          ),
      child: BlocBuilder<BloomController, BloomModel>(
        builder: (BuildContext context, BloomModel model) {
          return DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) {
              final defaultLightColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.green,
                contrastLevel: 0,
              );
              final themeDataLight = ThemeData(
                fontFamily: 'Jost',
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
                fontFamily: 'Jost',
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
                routerConfig: routerConfig,
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
