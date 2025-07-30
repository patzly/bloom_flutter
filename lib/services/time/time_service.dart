import 'package:bloom_flutter/services/time/listener/time_listener.dart';

enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  void setListener(TimeListener listener);

  void loadFromStorage();

  void setUserPresence(UserPresence presence);

  Future<void> update();

  int getSessionTimeMillis();

  double getSessionTimeFraction();

  int getSessionTimeRemainingMillis();

  int getSessionTimeToleranceMillis();

  double getSessionTimeToleranceFraction();

  int getBreakTimeMillis();

  int getScreenTimeMillis();

  double getScreenTimeFraction();

  int getStreak();

  int getWaterDrops();
}
