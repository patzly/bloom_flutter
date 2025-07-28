abstract class StorageService {
  Future<void> saveString(String key, String value);

  String? getString(String key);

  Future<void> saveBool(String key, bool value);

  bool? getBool(String key);

  Future<void> saveInt(String key, int value);

  int? getInt(String key);

  Future<void> saveDouble(String key, double value);

  double? getDouble(String key);

  Future<void> remove(String key);

  Future<void> clear();
}
