import 'dart:io';

import 'package:bloom_flutter/services/foreground/phone_time_service.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service_android_impl.dart';

class PhoneTimeServiceImpl {
  static final PhoneTimeService instance = _createInstance();

  static PhoneTimeService _createInstance() {
    if (Platform.isAndroid) {
      return PhoneTimeServiceAndroidImpl();
    } else {
      return _PhoneTimeServiceDefaultImpl();
    }
  }
}

class _PhoneTimeServiceDefaultImpl implements PhoneTimeService {
  late void Function(Object data) _callback;

  @override
  void init(void Function(Object data) callback) {
    _callback = callback;
  }

  @override
  void dispose() {}
}