import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BloomController extends Cubit<BloomModel> {
  BloomController(super.initialState);

  void dispose() {
    super.close();
  }

  void navigateToSettings();

  Future<void> initService();

  void startService();

  void stopService();

  void setBrightnessLevel(BrightnessLevel brightnessLevel);

  void setContrastLevel(ContrastLevel contrastLevel);

  void setUseDynamicColors(bool useDynamicColors);

  void setSessionTimeMax(Duration sessionTimeMax);

  void setBreakTimeMin(Duration breakTimeMin);

  void setScreenTimeMax(Duration screenTimeMax);

  void setDailyResetTime(TimeOfDay dailyResetTime);
}
