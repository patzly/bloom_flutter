import 'package:bloom_flutter/constants.dart';

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

  BloomModel({
    this.sessionTimeFraction = Defaults.sessionTimeFraction,
    this.sessionTimeToleranceFraction = Defaults.sessionTimeToleranceFraction,
    this.screenTimeFraction = Defaults.screenTimeFraction,
    this.isServiceRunning = false,
    this.brightnessLevel = BrightnessLevel.auto,
    this.contrastLevel = ContrastLevel.standard,
    this.useDynamicColors = true,
    this.sessionTimeMax = const Duration(minutes: Defaults.sessionTimeMax),
    this.breakTimeMin = const Duration(minutes: Defaults.breakTimeMin),
    this.screenTimeMax = const Duration(minutes: Defaults.screenTimeMax)
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
    );
  }
}
