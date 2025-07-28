import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  StorageServiceImpl._(this._prefs);

  static Future<StorageServiceImpl> create() async {
    // Ensure Flutter bindings before accessing shared preferences
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    return StorageServiceImpl._(prefs);
  }

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
