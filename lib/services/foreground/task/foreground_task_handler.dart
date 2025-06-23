import 'dart:async';

import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:screen_state/screen_state.dart';

class ForegroundTaskHandler extends TaskHandler {
  final TimeService timeService;
  late Screen _screen;
  late StreamSubscription<ScreenStateEvent> _subscription;

  ForegroundTaskHandler(this.timeService);

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('onStart(starter: ${starter.name})');

    _screen = new Screen();
    try {
      _subscription = _screen.screenStateStream.listen((
        ScreenStateEvent event,
      ) {
        _onScreenStateChanged(event);
      });
    } catch (exception) {
      print(exception);
    }
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    // Send data to main isolate.
    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
    FlutterForegroundTask.sendDataToMain(data);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _subscription.cancel();
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    debugPrint('onReceiveData: $data');
  }

  void _onScreenStateChanged(ScreenStateEvent event) {
    if (event == ScreenStateEvent.SCREEN_OFF) {
      timeService.setUserPresence(UserPresence.OFF);
    } else if (event == ScreenStateEvent.SCREEN_ON) {
      timeService.setUserPresence(UserPresence.LOCKED);
    } else {
      timeService.setUserPresence(UserPresence.UNLOCKED);
    }
  }
}
