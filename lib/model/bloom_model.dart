import 'package:bloom_flutter/constants.dart';
import 'package:flutter/material.dart';

class BloomModel {
  final double sessionTimeFraction;
  final double sessionTimeToleranceFraction;
  final double screenTimeFraction;
  final bool isServiceRunning;
  final BrightnessLevel brightnessLevel;
  final ContrastLevel contrastLevel;
  final bool useDynamicColors;
  final Duration sessionTimeMax;
  final Duration breakTimeMin;
  final Duration screenTimeMax;
  final TimeOfDay dailyResetTime;
  final int daysStreak;
  final int waterDrops;

  BloomModel({
    this.sessionTimeFraction = Defaults.sessionTimeFraction,
    this.sessionTimeToleranceFraction = Defaults.sessionTimeToleranceFraction,
    this.screenTimeFraction = Defaults.screenTimeFraction,
    this.isServiceRunning = false,
    this.brightnessLevel = BrightnessLevel.auto,
    this.contrastLevel = ContrastLevel.standard,
    this.useDynamicColors = Defaults.useDynamicColors,
    this.sessionTimeMax = Defaults.sessionTimeMax,
    this.breakTimeMin = Defaults.breakTimeMin,
    this.screenTimeMax = Defaults.screenTimeMax,
    this.dailyResetTime = Defaults.dailyResetTime,
    this.daysStreak = Defaults.daysStreak,
    this.waterDrops = Defaults.waterDrops,
  });

  BloomModel copyWith({
    double? sessionTimeFraction,
    double? sessionTimeToleranceFraction,
    double? screenTimeFraction,
    bool? isServiceRunning,
    BrightnessLevel? brightnessLevel,
    ContrastLevel? contrastLevel,
    bool? useDynamicColors,
    Duration? sessionTimeMax,
    Duration? breakTimeMin,
    Duration? screenTimeMax,
    TimeOfDay? dailyResetTime,
    int? daysStreak,
    int? waterDrops,
  }) {
    return BloomModel(
      sessionTimeFraction: sessionTimeFraction ?? this.sessionTimeFraction,
      sessionTimeToleranceFraction:
          sessionTimeToleranceFraction ?? this.sessionTimeToleranceFraction,
      screenTimeFraction: screenTimeFraction ?? this.screenTimeFraction,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
      brightnessLevel: brightnessLevel ?? this.brightnessLevel,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      sessionTimeMax: sessionTimeMax ?? this.sessionTimeMax,
      breakTimeMin: breakTimeMin ?? this.breakTimeMin,
      screenTimeMax: screenTimeMax ?? this.screenTimeMax,
      dailyResetTime: dailyResetTime ?? this.dailyResetTime,
      daysStreak: daysStreak ?? this.daysStreak,
      waterDrops: waterDrops ?? this.waterDrops,
    );
  }
}
