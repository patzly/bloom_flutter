import 'dart:io';

import 'package:bloom_flutter/services/foreground/phone_time_service_android_impl.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service_default_impl.dart';

abstract class PhoneTimeService {
  Future<void> init(void Function(Object data) callback);

  void dispose();

  Future<bool> start();

  Future<bool> stop();

  Future<bool> isRunning();

  factory PhoneTimeService() {
    if (Platform.isAndroid) {
      return PhoneTimeServiceAndroidImpl();
    } else {
      return PhoneTimeServiceDefaultImpl();
    }
  }
}
