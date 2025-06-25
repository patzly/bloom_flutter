import 'package:bloom_flutter/services/time/time_service.dart';

class TimeServiceSingleton {
  static TimeService? _instance;

  static void setInstance(TimeService instance) {
    _instance = instance;
  }

  static TimeService getInstance() {
    if (_instance == null) {
      throw Exception("TimeService not initialized");
    }
    return _instance!;
  }

  static bool isInitialized() => _instance != null;
}