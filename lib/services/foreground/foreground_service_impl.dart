import 'dart:io';

import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/foreground/foreground_service_android_impl.dart';
import 'package:bloom_flutter/services/foreground/foreground_service_default_impl.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/foundation.dart';

class ForegroundServiceImpl {
  static ForegroundService create(TimeService timeService) {
    if (!kIsWeb && Platform.isAndroid) {
      return ForegroundServiceAndroidImpl(timeService);
    } else {
      return ForegroundServiceDefaultImpl(timeService);
    }
  }
}