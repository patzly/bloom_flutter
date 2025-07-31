abstract class NotificationService {
  Future<void> init();

  Future<void> createChannels();

  Future<void> updateLiveUpdateNotification({
    required String title,
    required String text,
  });

  Future<void> updateLiveUpdateLastMinuteNotification({
    required String title,
    required String text,
  });

  Future<void> cancelLiveUpdateNotification();

  Future<void> cancelLiveUpdateLastMinuteNotification();

  Future<void> updateEventNotification({
    required String title,
    required String text,
  });

  Future<void> cancelEventNotification();
}
