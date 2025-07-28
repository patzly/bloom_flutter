import 'dart:async';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:screen_state/screen_state.dart';

class ForegroundTaskHandler extends TaskHandler {
  late final TimeService timeService;
  late Screen _screen;
  late StreamSubscription<ScreenStateEvent> _subscription;

  ForegroundTaskHandler(this.timeService);

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');

    timeService.loadFromStorage();
    timeService.setUserPresence(UserPresence.UNLOCKED);
    _update();

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
  void onRepeatEvent(DateTime timestamp) async {
    _update();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _subscription.cancel();
  }

  @override
  void onReceiveData(Object data) {
    debugPrint('onReceiveData: $data');
    if (data == ActionData.timePrefsChanged) {
      timeService.loadFromStorage();
    }
  }

  void _update() async {
    await timeService.update();

    final Map<String, dynamic> data = {
      TransactionKeys.sessionTimeMillis: timeService.getSessionTimeMillis(),
      TransactionKeys.sessionTimeFraction: timeService.getSessionTimeFraction(),
      TransactionKeys.sessionTimeToleranceMillis:
          timeService.getSessionTimeToleranceMillis(),
      TransactionKeys.sessionTimeRemainingMillis:
          timeService.getSessionTimeRemainingMillis(),
      TransactionKeys.sessionTimeToleranceFraction:
          timeService.getSessionTimeToleranceFraction(),
      TransactionKeys.breakTimeMillis: timeService.getBreakTimeMillis(),
      TransactionKeys.screenTimeMillis: timeService.getScreenTimeMillis(),
      TransactionKeys.screenTimeFraction: timeService.getScreenTimeFraction(),
      TransactionKeys.daysStreak: timeService.getDaysStreak(),
      TransactionKeys.waterDrops: timeService.getWaterDrops(),
    };
    FlutterForegroundTask.sendDataToMain(data);
  }

  void _onScreenStateChanged(ScreenStateEvent event) {
    if (event == ScreenStateEvent.SCREEN_OFF) {
      timeService.setUserPresence(UserPresence.OFF);
    } else if (event == ScreenStateEvent.SCREEN_ON) {
      timeService.setUserPresence(UserPresence.LOCKED);
    } else {
      timeService.setUserPresence(UserPresence.UNLOCKED);
    }
    FlutterForegroundTask.updateService(
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction:
            event == ScreenStateEvent.SCREEN_UNLOCKED
                ? ForegroundTaskEventAction.repeat(
                  Constants.updateInterval.inMilliseconds,
                )
                : ForegroundTaskEventAction.nothing(),
      ),
    );
  }
}
