abstract class BackgroundService {
  Future<void> init(void Function(Object data) callback);

  void dispose();

  Future<bool> start();

  Future<bool> stop();

  Future<bool> isRunning();

  void sendDataToService(Object data);

  Future<bool> hasNotificationPermission();

  Future<bool> isNotificationPermissionDeniedPermanently();

  Future<bool> requestNotificationPermission();
}
