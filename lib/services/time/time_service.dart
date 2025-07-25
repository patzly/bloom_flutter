enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  Future<void> loadFromPrefs();

  void setUserPresence(UserPresence presence);

  Future<void> update();

  double getSessionTimeFraction();

  double getSessionTimeToleranceFraction();

  double getScreenTimeFraction();

  int getDaysStreak();

  int getWaterDrops();
}
