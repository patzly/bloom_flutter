import 'package:bloom_flutter/bloom_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Keep splash screen until controller is initialized
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('de'),
      child: const BloomApp(),
    ),
  );
}
