import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller_impl.dart';
import 'package:bloom_flutter/services/background/background_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:bloom_flutter/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigationService extends Mock implements NavigationService {}

class MockBackgroundService extends Mock implements BackgroundService {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockNavigationService navigationService;
  late MockBackgroundService backgroundService;
  late MockStorageService storageService;
  late BloomControllerImpl controller;

  setUp(() {
    navigationService = MockNavigationService();
    backgroundService = MockBackgroundService();
    storageService = MockStorageService();

    // Mocks auf Default-Werte setzen
    when(() => storageService.getDouble(any())).thenReturn(null);
    when(() => storageService.getInt(any())).thenReturn(null);
    when(() => storageService.getBool(any())).thenReturn(null);
    when(() => storageService.getString(any())).thenReturn(null);

    when(() => backgroundService.init(any())).thenAnswer((_) async => null);
    when(() => backgroundService.isRunning()).thenAnswer((_) async => false);
    when(() => backgroundService.start()).thenAnswer((_) async => true);
    when(() => backgroundService.stop()).thenAnswer((_) async => true);
    when(() => backgroundService.dispose()).thenAnswer((_) async {});

    controller = BloomControllerImpl(
      navigationService: navigationService,
      backgroundService: backgroundService,
      storageService: storageService,
    );
  });

  test('Initial state is loaded from storage', () {
    final state = controller.state;
    expect(state.brightnessLevel, equals(BrightnessLevel.auto));
    expect(state.isServiceRunning, isFalse);
  });

  test('navigateToSettings calls navigationService.navigateToSettings', () {
    controller.navigateToSettings();
    verify(() => navigationService.navigateToSettings()).called(1);
  });

}

