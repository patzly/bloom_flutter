import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/controller/bloom_controller_impl.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/routs/app_router.dart';
import 'package:bloom_flutter/services/foreground/foreground_service_impl.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
import 'package:bloom_flutter/services/storage/storage_service_impl.dart';
import 'package:bloom_flutter/services/time/time_service_impl.dart';
import 'package:bloom_flutter/theme/bloom_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

class BloomApp extends StatefulWidget {
  const BloomApp({super.key});

  @override
  State<BloomApp> createState() => _BloomAppState();
}

class _BloomAppState extends State<BloomApp> {
  BloomController? _controller;
  late final GoRouter _router;
  late final Future<void> _initController;

  @override
  void initState() {
    super.initState();

    _router = app_routs.createRouter();

    _initController = Future(() async {
      // Initialize services and controller
      final navigationService = NavigationServiceImpl(_router);
      final storageService = await StorageServiceImpl.create();
      final foregroundService = await ForegroundServiceImpl.create(
        TimeServiceImpl(storageService),
      );
      _controller = BloomControllerImpl(
        navigationService: navigationService,
        foregroundService: foregroundService,
        storageService: storageService,
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initController,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Wait for controller to be initialized while splash screen is shown
          return const SizedBox();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Remove splash screen after the first frame is drawn
          FlutterNativeSplash.remove();
        });
        return BlocProvider<BloomController>.value(
          value: _controller!,
          child: BlocBuilder<BloomController, BloomModel>(
            builder: (context, model) {
              return DynamicColorBuilder(
                builder: (lightColorScheme, darkColorScheme) {
                  return MaterialApp.router(
                    title: 'Bloom',
                    routerConfig: _router,
                    themeMode: switch (model.brightnessLevel) {
                      BrightnessLevel.auto => ThemeMode.system,
                      BrightnessLevel.light => ThemeMode.light,
                      BrightnessLevel.dark => ThemeMode.dark,
                    },
                    theme: BloomTheme.lightTheme(
                      dynamicScheme: lightColorScheme,
                      useDynamicColors: model.useDynamicColors,
                      contrastLevel: model.contrastLevel,
                    ),
                    darkTheme: BloomTheme.darkTheme(
                      dynamicScheme: darkColorScheme,
                      useDynamicColors: model.useDynamicColors,
                      contrastLevel: model.contrastLevel,
                    ),
                    debugShowCheckedModeBanner: false,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
