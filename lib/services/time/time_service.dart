enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  void setUserPresence(UserPresence presence);
  Future<void> update();
  double getSessionTimeFraction();
  double getSessionTimeToleranceFraction();
  double getScreenTimeFraction();
}
