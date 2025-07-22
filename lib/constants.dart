import 'package:flutter/material.dart';

class Constants {
  static const sessionTimeTolerance = 1; // in minutes (default is 5)
  static const updateInterval = 1000; // in milliseconds
}

class PrefKeys {
  static const brightnessLevel = 'brightnessLevel';
  static const contrastLevel = 'contrastLevel';
  static const useDynamicColors = 'useDynamicColors';
  static const sessionTimeFraction = 'sessionTimeFraction';
  static const sessionTimeToleranceFraction = 'sessionTimeToleranceFraction';
  static const sessionTimeMax = 'sessionTimeMax';
  static const breakTimeMin = 'breakTimeMin';
  static const screenTimeFraction = 'screenTimeFraction';
  static const screenTimeMax = 'screenTimeMax';
  static const dailyResetHour = 'dailyResetHour';
  static const dailyResetMinute = 'dailyResetMinute';
}

class Defaults {
  static const brightnessLevel = BrightnessLevel.auto;
  static const contrastLevel = ContrastLevel.standard;
  static const useDynamicColors = false;
  static const sessionTimeFraction = 0.0;
  static const sessionTimeToleranceFraction = 0.0;
  static const sessionTimeMax = Duration(minutes: 10);
  static const breakTimeMin = Duration(minutes: 10);
  static const screenTimeFraction = 0.0;
  static const screenTimeMax = Duration(minutes: 180);
  static const dailyResetTime = TimeOfDay(hour: 3, minute: 0);
}

enum BrightnessLevel { auto, light, dark }

enum ContrastLevel { standard, medium, high }