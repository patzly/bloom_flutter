import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BloomModel', () {
    test('Default values are correctly set', () {
      final model = BloomModel();

      expect(model.sessionTime, Duration.zero);
      expect(model.sessionTimeFraction, 0.0);
      expect(model.sessionTimeRemaining, Duration.zero);
      expect(model.sessionTimeTolerance, Duration.zero);
      expect(model.sessionTimeToleranceFraction, 0.0);
      expect(model.breakTime, Duration.zero);
      expect(model.screenTime, Duration.zero);
      expect(model.screenTimeFraction, 0.0);
      expect(model.streak, 0);
      expect(model.waterDrops, 0);
      expect(model.hasDriedOut, isFalse);
      expect(model.isServiceRunning, isFalse);
      expect(model.brightnessLevel, BrightnessLevel.auto);
      expect(model.contrastLevel, ContrastLevel.standard);
      expect(model.useDynamicColors, Defaults.useDynamicColors);
      expect(model.sessionTimeMax, Defaults.sessionTimeMax);
      expect(model.breakTimeMin, Defaults.breakTimeMin);
      expect(model.screenTimeMax, Defaults.screenTimeMax);
      expect(model.dailyResetTime, Defaults.dailyResetTime);
    });

    test('copyWith returns a modified copy', () {
      final original = BloomModel();
      final updated = original.copyWith(
        streak: 5,
        hasDriedOut: true,
        sessionTime: Duration(minutes: 30),
      );

      expect(updated.streak, 5);
      expect(updated.hasDriedOut, true);
      expect(updated.sessionTime, Duration(minutes: 30));

      expect(original.streak, 0);
      expect(original.hasDriedOut, false);
      expect(original.sessionTime, Duration.zero);
    });
  });
}
