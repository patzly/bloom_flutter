import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/foreground/task/foreground_task_handler.dart';
import 'package:bloom_flutter/services/time/time_service_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(
    ForegroundTaskHandler(TimeServiceImpl()),
  );
}

class ForegroundServiceAndroidImpl implements ForegroundService {
  late void Function(Object data) _callback;

  @override
  Future<void> init(void Function(Object data) callback) async {
    _callback = callback;
    FlutterForegroundTask.addTaskDataCallback(_callback);
    // Request permissions and initialize the service.
    await _requestPermissions();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'background_service',
        channelName: 'Background service',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: false,
      ),
    );
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_callback);
  }

  @override
  Future<bool> start() async {
    final result = await FlutterForegroundTask.startService(
      notificationTitle: "Screen time service is running",
      notificationText:
          "This notification is required to keep the service alive",
      // meta data added in android manifest
      notificationIcon: NotificationIcon(metaDataName: "notification_icon"),
      callback: startCallback,
    );
    if (result is ServiceRequestFailure) {
      debugPrint('Error starting the service: ${result.error}');
    }
    return result is ServiceRequestSuccess;
  }

  @override
  Future<bool> stop() async {
    final result = await FlutterForegroundTask.stopService();
    if (result is ServiceRequestFailure) {
      debugPrint('Error stopping the service: ${result.error}');
    }
    return result is ServiceRequestSuccess;
  }

  @override
  Future<bool> isRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }

  Future<void> _requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    // Android 12+, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }
}
