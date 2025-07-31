import 'package:bloom_flutter/services/notification/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceImpl implements NotificationService {
  static const String _channelIdLiveUpdates = 'live_updates';
  static const String _channelIdEvents = 'events';
  static const int notificationIdLiveUpdate = 0;
  static const int notificationIdLiveUpdateLastMinute = 1;
  static const int notificationIdEvent = 2;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('ic_rounded_potted_plant');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _plugin.initialize(initSettings);
  }

  @override
  Future<void> createChannels() async {
    const AndroidNotificationChannel liveUpdatesChannel =
        AndroidNotificationChannel(
          _channelIdLiveUpdates,
          'Live Updates',
          importance: Importance.max,
        );
    const AndroidNotificationChannel eventsChannel = AndroidNotificationChannel(
      _channelIdEvents,
      'Events',
      importance: Importance.defaultImportance,
    );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(liveUpdatesChannel);
    await androidPlugin?.createNotificationChannel(eventsChannel);
  }

  @override
  Future<void> updateLiveUpdateNotification({
    required String title,
    required String text,
  }) async {
    await _plugin.show(
      notificationIdLiveUpdate,
      title,
      text,
      _liveUpdateDetails(),
    );
  }

  @override
  Future<void> updateLiveUpdateLastMinuteNotification({
    required String title,
    required String text,
  }) async {
    await _plugin.show(
      notificationIdLiveUpdateLastMinute,
      title,
      text,
      _liveUpdateDetails(),
    );
  }

  @override
  Future<void> cancelLiveUpdateNotification() async {
    await _plugin.cancel(notificationIdLiveUpdate);
  }

  @override
  Future<void> cancelLiveUpdateLastMinuteNotification() async {
    await _plugin.cancel(notificationIdLiveUpdateLastMinute);
  }

  @override
  Future<void> updateEventNotification({
    required String title,
    required String text,
  }) async {
    await _plugin.show(notificationIdEvent, title, text, _eventDetails());
  }

  @override
  Future<void> cancelEventNotification() async {
    await _plugin.cancel(notificationIdEvent);
  }

  NotificationDetails _liveUpdateDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelIdLiveUpdates,
        'Live Updates',
        importance: Importance.max,
        priority: Priority.max,
        ongoing: true,
        onlyAlertOnce: true,
        showWhen: false,
        styleInformation: BigTextStyleInformation(''),
        visibility: NotificationVisibility.public,
        icon: 'ic_rounded_potted_plant',
      ),
    );
  }

  NotificationDetails _eventDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelIdEvents,
        'Events',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        ongoing: false,
        onlyAlertOnce: false,
        showWhen: true,
        styleInformation: BigTextStyleInformation(''),
        visibility: NotificationVisibility.public,
        icon: 'ic_rounded_potted_plant',
      ),
    );
  }
}
