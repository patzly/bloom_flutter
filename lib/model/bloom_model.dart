import 'package:bloom_flutter/constants.dart';

class BloomModel {
  final double sessionTimeFraction;
  final double sessionTimeToleranceFraction;
  final double screenTimeFraction;
  final bool isServiceRunning;
  final BrightnessLevel brightnessLevel;
  final ContrastLevel contrastLevel;

  BloomModel({
    this.sessionTimeFraction = Defaults.sessionTimeFraction,
    this.sessionTimeToleranceFraction = Defaults.sessionTimeToleranceFraction,
    this.screenTimeFraction = Defaults.screenTimeFraction,
    this.isServiceRunning = false,
    this.brightnessLevel = BrightnessLevel.auto,
    this.contrastLevel = ContrastLevel.standard,
  });

  BloomModel copyWith({
    double? sessionTimeFraction,
    double? sessionTimeToleranceFraction,
    double? screenTimeFraction,
    bool? isServiceRunning,
    BrightnessLevel? brightnessLevel,
    ContrastLevel? contrastLevel,
  }) {
    return BloomModel(
      sessionTimeFraction: sessionTimeFraction ?? this.sessionTimeFraction,
      sessionTimeToleranceFraction:
          sessionTimeToleranceFraction ?? this.sessionTimeToleranceFraction,
      screenTimeFraction: screenTimeFraction ?? this.screenTimeFraction,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
      brightnessLevel: brightnessLevel ?? this.brightnessLevel,
      contrastLevel: contrastLevel ?? this.contrastLevel,
    );
  }
}
