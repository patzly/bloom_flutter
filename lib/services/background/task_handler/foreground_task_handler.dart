import 'dart:async';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/extensions/time_extensions.dart';
import 'package:bloom_flutter/services/notification/notification_service.dart';
import 'package:bloom_flutter/services/time/listener/time_listener.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:screen_state/screen_state.dart';

class ForegroundTaskHandler extends TaskHandler implements TimeListener {
  late final TimeService timeService;
  late final NotificationService notificationService;
  late Screen _screen;
  late StreamSubscription<ScreenStateEvent> _subscription;

  ForegroundTaskHandler({
    required this.timeService,
    required this.notificationService,
  });

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');

    notificationService.init();
    notificationService.createChannels();

    timeService.setListener(this);
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
    if (data == ActionData.update) {
      _update();
    } else if (data == ActionData.timePrefsChanged) {
      timeService.loadFromStorage();
    }
  }

  @override
  void onPhoneTimeIncreased() {
    double sessionTimeToleranceFraction =
        timeService.getSessionTimeToleranceFraction();
    if (sessionTimeToleranceFraction > 0 && sessionTimeToleranceFraction < 1) {
      // create live update
      int breakTimeMillis = timeService.getBreakTimeMillis();
      String breakTimeString =
          Duration(
            milliseconds: breakTimeMillis,
          ).toPrettyStringRoundSecondsUp();
      int remainingMillis = timeService.getSessionTimeRemainingMillis();
      String remainingString =
          Duration(
            milliseconds: remainingMillis,
          ).toPrettyStringRoundSecondsDown();
      notificationService.updateLiveUpdateNotification(
        title: "Deine Blume braucht Wasser!",
        text:
            "Leg dein Smartphone für mindestens $breakTimeString weg, damit sie ausreichend gegossen wird. Ansonsten vertrocknet sie in $remainingString.",
      );
    }
  }

  @override
  void onToleranceExceeded() {
    notificationService.cancelLiveUpdateNotification();
  }

  @override
  void onBreak() {
    notificationService.cancelLiveUpdateNotification();
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
      TransactionKeys.streak: timeService.getStreak(),
      TransactionKeys.waterDrops: timeService.getWaterDrops(),
    };
    FlutterForegroundTask.sendDataToMain(data);
  }

  void _onScreenStateChanged(ScreenStateEvent event) {
    ForegroundTaskEventAction eventAction;
    if (event == ScreenStateEvent.SCREEN_OFF) {
      timeService.setUserPresence(UserPresence.OFF);
      eventAction = ForegroundTaskEventAction.nothing();
    } else if (event == ScreenStateEvent.SCREEN_ON) {
      timeService.setUserPresence(UserPresence.LOCKED);
      eventAction = ForegroundTaskEventAction.nothing();
    } else {
      timeService.setUserPresence(UserPresence.UNLOCKED);
      eventAction = ForegroundTaskEventAction.repeat(
        Constants.updateInterval.inMilliseconds,
      );
    }
    FlutterForegroundTask.updateService(
      foregroundTaskOptions: ForegroundTaskOptions(eventAction: eventAction),
    );
  }
}
