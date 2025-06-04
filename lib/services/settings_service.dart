import 'package:bloom_flutter/screens/home/model/home_model.dart';

class SettingsService implements ISettingsService {
  @override
  Future<HomeModel> fetchHomeData() async {
    // Beispiel: Hole Daten aus SharedPreferences oder API
    return HomeModel(
      sessionTime: const Duration(minutes: 15),
      screenTime: const Duration(minutes: 30),
      exceededTime: const Duration(minutes: 2, seconds: 35),
    );
  }
}

abstract class ISettingsService {
  Future<HomeModel> fetchHomeData();
}