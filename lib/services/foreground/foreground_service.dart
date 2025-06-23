abstract class ForegroundService {
  Future<void> init(void Function(Object data) callback);

  void dispose();

  Future<bool> start();

  Future<bool> stop();

  Future<bool> isRunning();
}
