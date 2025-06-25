import 'package:bloom_flutter/constants.dart';

class BloomModel {
  final double sessionTimeFraction;
  final double sessionTimeToleranceFraction;
  final double screenTimeFraction;
  final bool isServiceRunning;

  BloomModel({
    this.sessionTimeFraction = Defaults.sessionTimeFraction,
    this.sessionTimeToleranceFraction = Defaults.sessionTimeToleranceFraction,
    this.screenTimeFraction = Defaults.screenTimeFraction,
    this.isServiceRunning = false,
  });

  BloomModel copyWith({
    double? sessionTimeFraction,
    double? sessionTimeToleranceFraction,
    double? screenTimeFraction,
    bool? isServiceRunning,
  }) {
    return BloomModel(
      sessionTimeFraction: sessionTimeFraction ?? this.sessionTimeFraction,
      sessionTimeToleranceFraction:
          sessionTimeToleranceFraction ?? this.sessionTimeToleranceFraction,
      screenTimeFraction: screenTimeFraction ?? this.screenTimeFraction,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
    );
  }
}
