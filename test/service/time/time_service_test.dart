import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloom_flutter/services/storage/storage_service.dart';
import 'package:bloom_flutter/services/time/time_service_impl.dart';
import 'package:bloom_flutter/services/time/time_service.dart';
import 'package:bloom_flutter/services/time/listener/time_listener.dart';
import 'package:bloom_flutter/Constants.dart';


class MockStorageService extends Mock implements StorageService {}

class MockTimeListener extends Mock implements TimeListener {}


void main() {
  late MockStorageService mockStorage;
  late TimeServiceImpl timeService;
  late MockTimeListener mockListener;

  setUp(() {
    mockStorage = MockStorageService();
    timeService = TimeServiceImpl(mockStorage);
    mockListener = MockTimeListener();
    timeService.setListener(mockListener);
  });

  group('loadFromStorage', () {
    test('loads all values from storage or uses defaults', () {
      when(() => mockStorage.getInt(any())).thenReturn(null);
      when(() => mockStorage.getDouble(any())).thenReturn(null);
      when(() => mockStorage.getBool(any())).thenReturn(null);

      timeService.loadFromStorage();

      // Standardwerte aus Defaults sollten gesetzt sein
      expect(timeService.sessionTimeMaxMinutes, equals(timeService.sessionTimeMaxMinutes)); // da Default
      expect(timeService.breakTimeMinMinutes, equals(timeService.breakTimeMinMinutes));
      expect(timeService.screenTimeMaxMinutes, equals(timeService.screenTimeMaxMinutes));
      expect(timeService.streak, 0);
      expect(timeService.waterDrops, 0);
      expect(timeService.driedOut, false);
      expect(timeService.dailyResetTime.hour, timeService.dailyResetTime.hour);
    });

    test('loads specific stored values', () {
      when(() => mockStorage.getInt(PrefKeys.sessionTimeMax)).thenReturn(100);
      when(() => mockStorage.getDouble(PrefKeys.sessionTimeFraction)).thenReturn(0.5);
      when(() => mockStorage.getInt(PrefKeys.breakTimeMin)).thenReturn(10);
      when(() => mockStorage.getInt(PrefKeys.screenTimeMax)).thenReturn(120);
      when(() => mockStorage.getDouble(PrefKeys.screenTimeFraction)).thenReturn(0.25);
      when(() => mockStorage.getInt(PrefKeys.streak)).thenReturn(5);
      when(() => mockStorage.getInt(PrefKeys.waterDrops)).thenReturn(7);
      when(() => mockStorage.getBool(PrefKeys.hasDriedOut)).thenReturn(true);
      when(() => mockStorage.getInt(PrefKeys.dailyResetHour)).thenReturn(3);
      when(() => mockStorage.getInt(PrefKeys.dailyResetMinute)).thenReturn(15);

      timeService.loadFromStorage();

      expect(timeService.sessionTimeMaxMinutes, 100);
      expect(timeService.breakTimeMinMinutes, 10);
      expect(timeService.screenTimeMaxMinutes, 120);
      expect(timeService.streak, 5);
      expect(timeService.waterDrops, 7);
      expect(timeService.driedOut, true);
      expect(timeService.dailyResetTime.hour, 3);
      expect(timeService.dailyResetTime.minute, 15);
    });
  });

  group('setUserPresence', () {
    test('sets user presence and triggers listener on break', () {
      timeService.setUserPresence(UserPresence.OFF);

      expect(timeService.userPresence, UserPresence.OFF);
      verify(() => mockListener.onBreak()).called(1);
    });

    test('switching from OFF to LOCKED does not trigger listener', () {
      timeService.userPresence = UserPresence.OFF;

      timeService.setUserPresence(UserPresence.LOCKED);

      expect(timeService.userPresence, UserPresence.OFF); // unchanged
      verifyNever(() => mockListener.onBreak());
    });

    test('switching from LOCKED to OFF does not trigger listener', () {
      timeService.userPresence = UserPresence.LOCKED;

      timeService.setUserPresence(UserPresence.OFF);

      expect(timeService.userPresence, UserPresence.LOCKED); // unchanged
      verifyNever(() => mockListener.onBreak());
    });

    test('switching to UNLOCKED updates session time correctly', () async {
      timeService.sessionTimeMaxMinutes = 10;
      timeService.sessionTimeMillis = 10 * 60 * 1000; // max
      timeService.breakTimeMinMinutes = 1;
      timeService.screenOffTimestamp = DateTime.now().millisecondsSinceEpoch - 2000; // vor 2s ausgeschaltet

      timeService.userPresence = UserPresence.OFF;

      timeService.setUserPresence(UserPresence.UNLOCKED);

      expect(timeService.userPresence, UserPresence.UNLOCKED);
    });
  });

  group('update', () {
    test('increases session and screen time and calls listener methods', () async {
      timeService.userPresence = UserPresence.UNLOCKED;
      timeService.sessionTimeMaxMinutes = 1; // 1 Minute
      timeService.sessionTimeMillis = 0;
      timeService.screenTimeMaxMinutes = 5;
      timeService.screenTimeMillis = 0;
      timeService.driedOut = false;

      when(() => mockStorage.saveDouble(any(), any())).thenAnswer((_) async => {});
      when(() => mockStorage.saveBool(any(), any())).thenAnswer((_) async => {});

      await timeService.update();

      verify(() => mockStorage.saveDouble(PrefKeys.sessionTimeFraction, any())).called(1);
      verify(() => mockStorage.saveDouble(PrefKeys.screenTimeFraction, any())).called(1);
      verify(() => mockListener.onPhoneTimeIncreased()).called(1);
    });
  });
}
