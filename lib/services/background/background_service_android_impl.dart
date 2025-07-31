import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/services/background/background_service.dart';
import 'package:bloom_flutter/services/background/task_handler/foreground_task_handler.dart';
import 'package:bloom_flutter/services/notification/notification_service.dart';
import 'package:bloom_flutter/services/notification/notification_service_impl.dart';
import 'package:bloom_flutter/services/storage/storage_service_impl.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:bloom_flutter/services/time/time_service_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  StorageServiceImpl.create().then((storageService) {
    TimeService timeService = TimeServiceImpl(storageService);
    NotificationService notificationService = NotificationServiceImpl();
    FlutterForegroundTask.setTaskHandler(
      ForegroundTaskHandler(
        timeService: timeService,
        notificationService: notificationService,
      ),
    );
  });
}

class BackgroundServiceAndroidImpl implements BackgroundService {
  late void Function(Object data) _callback;

  @override
  Future<void> init(void Function(Object data) callback) async {
    _callback = callback;
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_callback);
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_callback);
  }

  @override
  Future<bool> start() async {
    bool isRunning = await this.isRunning();
    if (!isRunning) {
      // Check notification permission
      final bool hasPermission = await this.hasNotificationPermission();
      if (!hasPermission) {
        debugPrint('Foreground task requires notification permission.');
        return false;
      }
      // Initialize foreground task
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'background_service',
          channelName: 'Background service',
          onlyAlertOnce: true,
        ),
        iosNotificationOptions: IOSNotificationOptions(),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(
            Constants.updateInterval.inMilliseconds,
          ),
          autoRunOnBoot: true,
          autoRunOnMyPackageReplaced: true,
          allowWakeLock: false,
        ),
      );
    }

    final result = await FlutterForegroundTask.startService(
      notificationTitle: 'Service zur Messung der Bildschirmzeit läuft',
      notificationText:
          'Diese Benachrichtigung ist erforderlich, um den Service am Laufen zu halten.',
      // meta data added in android manifest
      notificationIcon: NotificationIcon(metaDataName: 'notification_icon'),
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

  @override
  void sendDataToService(Object data) {
    FlutterForegroundTask.sendDataToTask(data);
  }

  @override
  Future<bool> hasNotificationPermission() async {
    final NotificationPermission permission =
        await FlutterForegroundTask.checkNotificationPermission();
    return permission == NotificationPermission.granted;
  }

  @override
  Future<bool> isNotificationPermissionDeniedPermanently() async {
    final NotificationPermission permission =
        await FlutterForegroundTask.checkNotificationPermission();
    return permission == NotificationPermission.permanently_denied;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final bool hasPermission = await this.hasNotificationPermission();
    if (hasPermission) {
      return true;
    } else {
      final NotificationPermission permission =
          await FlutterForegroundTask.requestNotificationPermission();
      return permission == NotificationPermission.granted;
    }
  }
}
