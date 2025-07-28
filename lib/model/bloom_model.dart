import 'package:bloom_flutter/constants.dart';
import 'package:flutter/material.dart';

class BloomModel {
  final Duration sessionTime;
  final double sessionTimeFraction;
  final Duration sessionTimeRemaining;
  final Duration sessionTimeTolerance;
  final double sessionTimeToleranceFraction;
  final Duration breakTime;
  final Duration screenTime;
  final double screenTimeFraction;
  final int daysStreak;
  final int waterDrops;
  final bool isServiceRunning;
  final BrightnessLevel brightnessLevel;
  final ContrastLevel contrastLevel;
  final bool useDynamicColors;
  final Duration sessionTimeMax;
  final Duration breakTimeMin;
  final Duration screenTimeMax;
  final TimeOfDay dailyResetTime;

  BloomModel({
    this.sessionTime = const Duration(),
    this.sessionTimeFraction = 0.0,
    this.sessionTimeRemaining = const Duration(),
    this.sessionTimeTolerance = const Duration(),
    this.sessionTimeToleranceFraction = 0.0,
    this.breakTime = const Duration(),
    this.screenTime = const Duration(),
    this.screenTimeFraction = 0.0,
    this.daysStreak = 0,
    this.waterDrops = 0,
    this.isServiceRunning = false,
    this.brightnessLevel = BrightnessLevel.auto,
    this.contrastLevel = ContrastLevel.standard,
    this.useDynamicColors = Defaults.useDynamicColors,
    this.sessionTimeMax = Defaults.sessionTimeMax,
    this.breakTimeMin = Defaults.breakTimeMin,
    this.screenTimeMax = Defaults.screenTimeMax,
    this.dailyResetTime = Defaults.dailyResetTime,
  });

  BloomModel copyWith({
    Duration? sessionTime,
    double? sessionTimeFraction,
    Duration? sessionTimeRemaining,
    Duration? sessionTimeTolerance,
    double? sessionTimeToleranceFraction,
    Duration? breakTime,
    Duration? screenTime,
    double? screenTimeFraction,
    int? daysStreak,
    int? waterDrops,
    bool? isServiceRunning,
    BrightnessLevel? brightnessLevel,
    ContrastLevel? contrastLevel,
    bool? useDynamicColors,
    Duration? sessionTimeMax,
    Duration? breakTimeMin,
    Duration? screenTimeMax,
    TimeOfDay? dailyResetTime,
  }) {
    return BloomModel(
      sessionTime: sessionTime ?? this.sessionTime,
      sessionTimeFraction: sessionTimeFraction ?? this.sessionTimeFraction,
      sessionTimeRemaining: sessionTimeRemaining ?? this.sessionTimeRemaining,
      sessionTimeTolerance: sessionTimeTolerance ?? this.sessionTimeTolerance,
      sessionTimeToleranceFraction:
          sessionTimeToleranceFraction ?? this.sessionTimeToleranceFraction,
      breakTime: breakTime ?? this.breakTime,
      screenTime: screenTime ?? this.screenTime,
      screenTimeFraction: screenTimeFraction ?? this.screenTimeFraction,
      daysStreak: daysStreak ?? this.daysStreak,
      waterDrops: waterDrops ?? this.waterDrops,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
      brightnessLevel: brightnessLevel ?? this.brightnessLevel,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      sessionTimeMax: sessionTimeMax ?? this.sessionTimeMax,
      breakTimeMin: breakTimeMin ?? this.breakTimeMin,
      screenTimeMax: screenTimeMax ?? this.screenTimeMax,
      dailyResetTime: dailyResetTime ?? this.dailyResetTime,
    );
  }
}
