enum UserPresence { UNLOCKED, LOCKED, OFF }

abstract class TimeService {
  void setUserPresence(UserPresence presence);
}
