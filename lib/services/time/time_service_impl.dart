import 'package:bloom_flutter/services/time/time_service.dart';

class TimeServiceImpl implements TimeService {
  UserPresence? userPresence = null;

  @override
  void setUserPresence(UserPresence presence) {
    if (userPresence == presence) {
      return;
    } else if ((userPresence == UserPresence.OFF &&
            presence == UserPresence.LOCKED) ||
        (userPresence == UserPresence.LOCKED && presence == UserPresence.OFF)) {
      // ignore because only changes in user present/not present count
      return;
    }
    userPresence = presence;
    print("User presence " + userPresence!.name);
  }
}
