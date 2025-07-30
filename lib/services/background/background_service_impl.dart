import 'dart:io';

import 'package:bloom_flutter/services/background/background_service.dart';
import 'package:bloom_flutter/services/background/background_service_android_impl.dart';
import 'package:bloom_flutter/services/background/background_service_default_impl.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/foundation.dart';

class BackgroundServiceImpl {
  static Future<BackgroundService> create(TimeService timeService) async {
    if (!kIsWeb && Platform.isAndroid) {
      // Foreground task needs to create its own instance of TimerService
      // because it runs in a separate isolate
      return BackgroundServiceAndroidImpl();
    } else {
      return BackgroundServiceDefaultImpl(timeService);
    }
  }
}
