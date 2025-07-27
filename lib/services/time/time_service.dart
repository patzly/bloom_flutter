enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  void loadFromStorage();

  void setUserPresence(UserPresence presence);

  Future<void> update();

  int getSessionTimeMillis();

  double getSessionTimeFraction();

  int getSessionTimeRemainingMillis();

  int getSessionTimeToleranceMillis();

  double getSessionTimeToleranceFraction();

  int getScreenTimeMillis();

  double getScreenTimeFraction();

  int getDaysStreak();

  int getWaterDrops();
}
