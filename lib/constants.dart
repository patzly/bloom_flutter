import 'package:flutter/material.dart';

class Constants {
  static const sessionTimeToleranceMax = Duration(minutes: 5);
  static const updateInterval = Duration(seconds: 1);
}

class PrefKeys {
  static const sessionTimeFraction = 'sessionTimeFraction';
  static const sessionTimeToleranceFraction = 'sessionTimeToleranceFraction';
  static const screenTimeFraction = 'screenTimeFraction';
  static const daysStreak = 'daysStreak';
  static const waterDrops = 'waterDrops';
  static const brightnessLevel = 'brightnessLevel';
  static const contrastLevel = 'contrastLevel';
  static const useDynamicColors = 'useDynamicColors';
  static const sessionTimeMax = 'sessionTimeMax';
  static const breakTimeMin = 'breakTimeMin';
  static const screenTimeMax = 'screenTimeMax';
  static const dailyResetHour = 'dailyResetHour';
  static const dailyResetMinute = 'dailyResetMinute';
}

class Defaults {
  static const brightnessLevel = BrightnessLevel.auto;
  static const contrastLevel = ContrastLevel.standard;
  static const useDynamicColors = false;
  static const sessionTimeMax = Duration(minutes: 10);
  static const sessionTimeToleranceMax = Duration(minutes: 5);
  static const breakTimeMin = Duration(minutes: 10);
  static const screenTimeMax = Duration(hours: 3);
  static const dailyResetTime = TimeOfDay(hour: 3, minute: 0);
}

class ActionData {
  static const timePrefsChanged = 'timePrefsChanged';
}

class TransactionKeys {
  static const sessionTimeMillis = 'sessionTimeMillis';
  static const sessionTimeFraction = 'sessionTimeFraction';
  static const sessionTimeToleranceMillis = 'sessionTimeToleranceMillis';
  static const sessionTimeToleranceFraction = 'sessionTimeToleranceFraction';
  static const screenTimeMillis = 'screenTimeMillis';
  static const screenTimeFraction = 'screenTimeFraction';
  static const daysStreak = 'daysStreak';
  static const waterDrops = 'waterDrops';
}

enum BrightnessLevel { auto, light, dark }

enum ContrastLevel { standard, medium, high }
