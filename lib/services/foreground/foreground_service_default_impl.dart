import 'package:bloom_flutter/services/foreground/foreground_service.dart';

class ForegroundServiceDefaultImpl implements ForegroundService {
  late void Function(Object data) _callback;

  @override
  Future<void> init(void Function(Object data) callback) {
    _callback = callback;
    return Future.value();
  }

  @override
  void dispose() {}

  @override
  Future<bool> start() {
    return Future.value(true);
  }

  @override
  Future<bool> stop() {
    return Future.value(true);
  }

  @override
  Future<bool> isRunning() {
    return Future.value(false);
  }
}