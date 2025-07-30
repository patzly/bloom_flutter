abstract class NotificationService {
  Future<void> init();

  Future<bool> hasPermission();

  Future<void> createChannels();

  Future<void> updateLiveUpdateNotification({
    required String title,
    required String text,
  });

  Future<void> cancelLiveUpdateNotification();

  Future<void> updateEventNotification({
    required String title,
    required String text,
  });

  Future<void> cancelEventNotification();
}
