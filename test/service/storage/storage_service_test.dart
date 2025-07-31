import 'package:bloom_flutter/services/storage/storage_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late StorageServiceImpl storageService;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageServiceImpl.testConstructor(mockPrefs);
  });

  group('StorageServiceImpl', () {
    test('saveString calls SharedPreferences.setString', () async {
      when(
        () => mockPrefs.setString('key', 'value'),
      ).thenAnswer((_) async => true);

      await storageService.saveString('key', 'value');

      verify(() => mockPrefs.setString('key', 'value')).called(1);
    });

    test('getString returns correct value from SharedPreferences', () {
      when(() => mockPrefs.getString('key')).thenReturn('value');

      final result = storageService.getString('key');

      expect(result, 'value');
      verify(() => mockPrefs.getString('key')).called(1);
    });

    test('saveBool calls SharedPreferences.setBool', () async {
      when(() => mockPrefs.setBool('key', true)).thenAnswer((_) async => true);

      await storageService.saveBool('key', true);

      verify(() => mockPrefs.setBool('key', true)).called(1);
    });

    test('getBool returns correct value from SharedPreferences', () {
      when(() => mockPrefs.getBool('key')).thenReturn(true);

      final result = storageService.getBool('key');

      expect(result, true);
      verify(() => mockPrefs.getBool('key')).called(1);
    });

    test('saveInt calls SharedPreferences.setInt', () async {
      when(() => mockPrefs.setInt('key', 42)).thenAnswer((_) async => true);

      await storageService.saveInt('key', 42);

      verify(() => mockPrefs.setInt('key', 42)).called(1);
    });

    test('getInt returns correct value from SharedPreferences', () {
      when(() => mockPrefs.getInt('key')).thenReturn(42);

      final result = storageService.getInt('key');

      expect(result, 42);
      verify(() => mockPrefs.getInt('key')).called(1);
    });

    test('saveDouble calls SharedPreferences.setDouble', () async {
      when(
        () => mockPrefs.setDouble('key', 3.14),
      ).thenAnswer((_) async => true);

      await storageService.saveDouble('key', 3.14);

      verify(() => mockPrefs.setDouble('key', 3.14)).called(1);
    });

    test('getDouble returns correct value from SharedPreferences', () {
      when(() => mockPrefs.getDouble('key')).thenReturn(3.14);

      final result = storageService.getDouble('key');

      expect(result, 3.14);
      verify(() => mockPrefs.getDouble('key')).called(1);
    });

    test('remove calls SharedPreferences.remove', () async {
      when(() => mockPrefs.remove('key')).thenAnswer((_) async => true);

      await storageService.remove('key');

      verify(() => mockPrefs.remove('key')).called(1);
    });

    test('clear calls SharedPreferences.clear', () async {
      when(() => mockPrefs.clear()).thenAnswer((_) async => true);

      await storageService.clear();

      verify(() => mockPrefs.clear()).called(1);
    });
  });
}
