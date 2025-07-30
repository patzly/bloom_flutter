import 'dart:math';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/services/storage/storage_service.dart';
import 'package:bloom_flutter/services/time/listener/time_listener.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:flutter/material.dart';

class TimeServiceImpl implements TimeService {
  final StorageService storageService;
  TimeListener? listener = null;
  UserPresence? userPresence = null;
  int sessionTimeMaxMinutes = 0;
  int sessionTimeMillis = 0;
  int breakTimeMinMinutes = 0;
  int screenTimeMaxMinutes = 0;
  int screenTimeMillis = 0;
  int screenOffTimestamp = 0;
  int streak = 0;
  int waterDrops = 0;
  TimeOfDay dailyResetTime = Defaults.dailyResetTime;

  TimeServiceImpl(this.storageService);

  @override
  void setListener(TimeListener listener) {
    this.listener = listener;
  }

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
    streak = storageService.getInt(PrefKeys.streak) ?? 0;
    waterDrops = storageService.getInt(PrefKeys.waterDrops) ?? 0;
    int dailyResetHour =
        storageService.getInt(PrefKeys.dailyResetHour) ??
        Defaults.dailyResetTime.hour;
    int dailyResetMinute =
        storageService.getInt(PrefKeys.dailyResetMinute) ??
        Defaults.dailyResetTime.minute;
    dailyResetTime = TimeOfDay(hour: dailyResetHour, minute: dailyResetMinute);
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
      listener?.onBreak();
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
        int breakTimeMinMillis = breakTimeMinMinutes * 60 * 1000;
        double breakTimeFraction = min(
          screenOffMillis.toDouble() / breakTimeMinMillis,
          1,
        );
        sessionTimeFraction = max(sessionTimeFraction - breakTimeFraction, 0);
        // calculate session time with break time fraction subtracted
        sessionTimeMillis = _computeSessionTimeMillis(sessionTimeFraction);
      }
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

      listener?.onPhoneTimeIncreased();
      if (isToleranceExceeded) {
        listener?.onToleranceExceeded();
      }
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
    int toleranceMillis = Constants.sessionTimeToleranceMax.inMilliseconds;
    int exceededMillis = getSessionTimeToleranceMillis();
    return max(toleranceMillis - exceededMillis, 0);
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
  int getBreakTimeMillis() {
    int breakTimeMinMillis = breakTimeMinMinutes * 60 * 1000;
    return breakTimeMinMillis + getSessionTimeToleranceMillis();
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
  int getStreak() {
    return streak;
  }

  @override
  int getWaterDrops() {
    return waterDrops;
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
