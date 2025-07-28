import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/time/time_service.dart';

// TODO: This class can be used to implement logic that works in a browser
class ForegroundServiceDefaultImpl implements ForegroundService {
  TimeService timeService;

  ForegroundServiceDefaultImpl(this.timeService);

  @override
  Future<void> init(void Function(Object data) callback) {
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

  @override
  void sendDataToService(Object data) {}
}