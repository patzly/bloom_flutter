enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  Future<void> loadFromPrefs();

  void setUserPresence(UserPresence presence);

  Future<void> update();

  int getSessionTimeMillis();

  double getSessionTimeFraction();

  int getSessionTimeToleranceMillis();

  double getSessionTimeToleranceFraction();

  int getScreenTimeMillis();

  double getScreenTimeFraction();

  int getDaysStreak();

  int getWaterDrops();
}
