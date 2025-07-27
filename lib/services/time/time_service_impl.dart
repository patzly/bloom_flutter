import 'dart:math';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/services/storage/storage_service.dart';
import 'package:bloom_flutter/services/time/time_service.dart';

class TimeServiceImpl implements TimeService {
  final StorageService storageService;
  UserPresence? userPresence = null;
  int sessionTimeMaxMinutes = 0;
  int sessionTimeMillis = 0;
  int breakTimeMinMinutes = 0;
  int screenTimeMaxMinutes = 0;
  int screenTimeMillis = 0;
  int screenOffTimestamp = 0;

  TimeServiceImpl(this.storageService);

  @override
  void loadFromStorage() {
    sessionTimeMaxMinutes =
        storageService.getInt(PrefKeys.sessionTimeMax) ??
        Defaults.sessionTimeMax.inMinutes;
    double sessionTimeFraction =
        storageService.getDouble(PrefKeys.sessionTimeFraction) ?? 0.0;
    sessionTimeMillis = _computeSessionTimeMillis(sessionTimeFraction);
    breakTimeMinMinutes =
        storageService.getInt(PrefKeys.breakTimeMin) ??
        Defaults.breakTimeMin.inMinutes;
    screenTimeMaxMinutes =
        storageService.getInt(PrefKeys.screenTimeMax) ??
        Defaults.screenTimeMax.inMinutes;
    double screenTimeFraction =
        storageService.getDouble(PrefKeys.screenTimeFraction) ?? 0.0;
    screenTimeMillis =
        (screenTimeFraction * screenTimeMaxMinutes * 60 * 1000).toInt();
  }

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

    if (presence == UserPresence.OFF || presence == UserPresence.LOCKED) {
      // save screen off timestamp
      screenOffTimestamp = DateTime.now().millisecondsSinceEpoch;
      // TODO: listener.onBreak();
    } else if (presence == UserPresence.UNLOCKED) {
      // calculate break time fraction
      int screenOnTimestamp = DateTime.now().millisecondsSinceEpoch;
      int screenOffMillis = screenOnTimestamp - screenOffTimestamp;
      if (screenOffTimestamp > 0 && screenOffMillis >= 0) {
        double sessionTimeFraction = getSessionTimeFraction();
        if (sessionTimeFraction > 1) {
          // first subtract break from exceeded session time
          int sessionTimeMaxMillis = sessionTimeMaxMinutes * 60 * 1000;
          int exceededMillis = max(sessionTimeMillis - sessionTimeMaxMillis, 0);
          int toleranceMillis = min(
            exceededMillis,
            Constants.sessionTimeToleranceMax.inMilliseconds,
          );
          int absoluteToleranceMillis =
              sessionTimeMaxMillis +
              Constants.sessionTimeToleranceMax.inMilliseconds;
          sessionTimeMillis = max(
            min(sessionTimeMillis, absoluteToleranceMillis) - screenOffMillis,
            sessionTimeMaxMillis,
          );
          // recalculate session time fraction
          sessionTimeFraction = getSessionTimeFraction();
          // subtract consumed screen off time
          screenOffMillis = max(screenOffMillis - toleranceMillis, 0);
        }
        int breakTimeMillis = breakTimeMinMinutes * 60 * 1000;
        double breakTimeFraction = min(
          screenOffMillis.toDouble() / breakTimeMillis,
          1,
        );
        sessionTimeFraction = max(sessionTimeFraction - breakTimeFraction, 0);
        // calculate session time with break time fraction subtracted
        sessionTimeMillis = _computeSessionTimeMillis(sessionTimeFraction);
      }
      // TODO: listener.onPhoneTimeChanged();
    }
  }

  @override
  Future<void> update() async {
    if (userPresence == UserPresence.UNLOCKED) {
      // update session time
      sessionTimeMillis += Constants.updateInterval.inMilliseconds;
      int absoluteToleranceMillis =
          (sessionTimeMaxMinutes +
              Constants.sessionTimeToleranceMax.inMinutes) *
          60 *
          1000;
      // callback exactly on time and not 1 second later
      absoluteToleranceMillis -= 1000;
      int toleranceMillisLastMinute = absoluteToleranceMillis - (60 * 1000);
      bool isToleranceLastMinute = false;
      if (sessionTimeMillis > toleranceMillisLastMinute) {
        if (sessionTimeMillis - Constants.updateInterval.inMilliseconds <=
            toleranceMillisLastMinute) {
          isToleranceLastMinute = true;
        }
      }
      bool isToleranceExceeded = false;
      if (sessionTimeMillis > absoluteToleranceMillis) {
        if (sessionTimeMillis - Constants.updateInterval.inMilliseconds <=
            absoluteToleranceMillis) {
          isToleranceExceeded = true;
        }
      }

      // update screen time
      screenTimeMillis += Constants.updateInterval.inMilliseconds;

      // save time to preferences
      storageService.saveDouble(
        PrefKeys.sessionTimeFraction,
        getSessionTimeFraction(),
      );
      storageService.saveDouble(
        PrefKeys.screenTimeFraction,
        getScreenTimeFraction(),
      );

      // TODO: listener.onPhoneTimeChanged();
      /* listener.onPhoneTimeIncreased();
      if (isToleranceLastMinute) {
        listener.onLastToleranceMinuteStarted();
      }
      if (isToleranceExceeded) {
        listener.onToleranceExceeded();
      }*/
    }
  }

  @override
  int getSessionTimeMillis() {
    return sessionTimeMillis;
  }

  @override
  double getSessionTimeFraction() {
    int sessionTimeMaxMillis = sessionTimeMaxMinutes * 60 * 1000;
    double fraction = max(
      min(sessionTimeMillis.toDouble() / sessionTimeMaxMillis, 1),
      0,
    );
    int exceededMillis = max(sessionTimeMillis - sessionTimeMaxMillis, 0);
    int toleranceMillis = Constants.sessionTimeToleranceMax.inMilliseconds;
    double exceededFraction = max(
      exceededMillis.toDouble() / toleranceMillis,
      0,
    );
    return max(min(fraction + exceededFraction, 2), 0);
  }

  @override
  int getSessionTimeRemainingMillis() {
    int exceededMillis = max(
      sessionTimeMillis - (sessionTimeMaxMinutes * 60 * 1000),
      0,
    );
    //print('Session time millis: $sessionTimeMillis sessionTimeMaxMinutes: ${sessionTimeMaxMinutes}');
    //print('Session time remaining millis: $exceededMillis toleranceMillis: ${getSessionTimeToleranceMillis()}');
    return max(getSessionTimeToleranceMillis() - exceededMillis, 0);
  }

  @override
  int getSessionTimeToleranceMillis() {
    return max(sessionTimeMillis - (sessionTimeMaxMinutes * 60 * 1000), 0);
  }

  @override
  double getSessionTimeToleranceFraction() {
    return max(getSessionTimeFraction() - 1, 0);
  }

  @override
  int getScreenTimeMillis() {
    return screenTimeMillis;
  }

  @override
  double getScreenTimeFraction() {
    double fraction =
        screenTimeMillis.toDouble() / (screenTimeMaxMinutes * 60 * 1000);
    return max(min(fraction, 1), 0);
  }

  @override
  int getDaysStreak() {
    // TODO: Implement streak logic
    return 0;
  }

  @override
  int getWaterDrops() {
    // TODO: Implement water drops logic
    return 0;
  }

  int _computeSessionTimeMillis(double sessionTimeFraction) {
    sessionTimeFraction = sessionTimeFraction.clamp(0, 2);
    int sessionTimeMaxMillis = sessionTimeMaxMinutes * 60 * 1000;
    if (sessionTimeFraction <= 1) {
      return (sessionTimeFraction * sessionTimeMaxMillis).toInt();
    } else {
      double exceededFraction = sessionTimeFraction - 1.0;
      int toleranceMillis =
          Constants.sessionTimeToleranceMax.inMinutes * 60 * 1000;
      int exceededMillis = (exceededFraction * toleranceMillis).toInt();
      return sessionTimeMaxMillis + exceededMillis;
    }
  }
}
