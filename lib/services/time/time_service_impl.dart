import 'dart:math';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeServiceImpl implements TimeService {
  SharedPreferences? prefs = null;
  UserPresence? userPresence = null;
  int sessionTimeMax = 0;
  int sessionTimeMillis = 0;
  int breakTimeMin = 0;
  int screenTimeMax = 0;
  int screenTimeMillis = 0;
  int screenOffTimestamp = 0;

  @override
  Future<void> loadFromPrefs() async {
    await WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();

    sessionTimeMax =
        prefs?.getInt(PrefKeys.sessionTimeMax) ?? Defaults.sessionTimeMax;
    double sessionTimeFraction =
        prefs?.getDouble(PrefKeys.sessionTimeFraction) ??
            Defaults.sessionTimeFraction;
    sessionTimeMillis = _computeSessionTimeMillis(sessionTimeFraction);
    breakTimeMin =
        prefs?.getInt(PrefKeys.breakTimeMin) ?? Defaults.breakTimeMin;
    screenTimeMax =
        prefs?.getInt(PrefKeys.sessionTimeMax) ?? Defaults.screenTimeMax;
    double screenTimeFraction =
        prefs?.getDouble(PrefKeys.sessionTimeFraction) ??
            Defaults.screenTimeFraction;
    screenTimeMillis = (screenTimeFraction * screenTimeMax * 60 * 1000).toInt();
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
          int sessionTimeMaxMillis = sessionTimeMax * 60 * 1000;
          int exceededMillis = max(sessionTimeMillis - sessionTimeMaxMillis, 0);
          int toleranceMillis = min(
            exceededMillis,
            Constants.sessionTimeTolerance * 60 * 1000,
          );
          int absoluteToleranceMillis =
              sessionTimeMaxMillis + Constants.sessionTimeTolerance * 60 * 1000;
          sessionTimeMillis = max(
            min(sessionTimeMillis, absoluteToleranceMillis) - screenOffMillis,
            sessionTimeMaxMillis,
          );
          // recalculate session time fraction
          sessionTimeFraction = getSessionTimeFraction();
          // subtract consumed screen off time
          screenOffMillis = max(screenOffMillis - toleranceMillis, 0);
        }
        int breakTimeMillis = breakTimeMin * 60 * 1000;
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
      sessionTimeMillis += Constants.updateInterval;
      int absoluteToleranceMillis =
          (sessionTimeMax + Constants.sessionTimeTolerance) * 60 * 1000;
      absoluteToleranceMillis -=
          1000; // callback exactly on time and not 1 second later
      int toleranceMillisLastMinute = absoluteToleranceMillis - (60 * 1000);
      bool isToleranceLastMinute = false;
      if (sessionTimeMillis > toleranceMillisLastMinute) {
        if (sessionTimeMillis - Constants.updateInterval <=
            toleranceMillisLastMinute) {
          isToleranceLastMinute = true;
        }
      }
      bool isToleranceExceeded = false;
      if (sessionTimeMillis > absoluteToleranceMillis) {
        if (sessionTimeMillis - Constants.updateInterval <=
            absoluteToleranceMillis) {
          isToleranceExceeded = true;
        }
      }

      // update screen time
      screenTimeMillis += Constants.updateInterval;

      // save time to preferences
      prefs?.setDouble(PrefKeys.sessionTimeFraction, getSessionTimeFraction());
      prefs?.setDouble(PrefKeys.screenTimeFraction, getScreenTimeFraction());

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
  double getSessionTimeFraction() {
    int sessionTimeMaxMillis = sessionTimeMax * 60 * 1000;
    double fraction = max(
      min(sessionTimeMillis.toDouble() / sessionTimeMaxMillis, 1),
      0,
    );
    int exceededMillis = max(sessionTimeMillis - sessionTimeMaxMillis, 0);
    int toleranceMillis = Constants.sessionTimeTolerance * 60 * 1000;
    double exceededFraction = max(
      exceededMillis.toDouble() / toleranceMillis,
      0,
    );
    return max(min(fraction + exceededFraction, 2), 0);
  }

  @override
  double getSessionTimeToleranceFraction() {
    return max(getSessionTimeFraction() - 1, 0);
  }

  @override
  double getScreenTimeFraction() {
    double fraction = screenTimeMillis.toDouble() / (screenTimeMax * 60 * 1000);
    return max(min(fraction, 1), 0);
  }

  int _computeSessionTimeMillis(double sessionTimeFraction) {
    sessionTimeFraction = sessionTimeFraction.clamp(0, 2);
    int sessionTimeMaxMillis = sessionTimeMax * 60 * 1000;
    if (sessionTimeFraction <= 1) {
      return (sessionTimeFraction * sessionTimeMaxMillis).toInt();
    } else {
      double exceededFraction = sessionTimeFraction - 1.0;
      int toleranceMillis = Constants.sessionTimeTolerance * 60 * 1000;
      int exceededMillis = (exceededFraction * toleranceMillis).toInt();
      return sessionTimeMaxMillis + exceededMillis;
    }
  }
}
