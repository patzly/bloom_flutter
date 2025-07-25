import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloomControllerImpl extends Cubit<BloomModel> implements BloomController {
  final NavigationService navigationService;
  final ForegroundService foregroundService;
  SharedPreferences? prefs = null;

  @override
  BloomControllerImpl({
    required this.navigationService,
    required this.foregroundService,
  }) : super(BloomModel()) {
    foregroundService.isRunning().then((value) {
      emit(state.copyWith(isServiceRunning: value));
    });
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      emit(
        state.copyWith(
          sessionTimeFraction: prefs.getDouble(PrefKeys.sessionTimeFraction),
          sessionTimeToleranceFraction: prefs.getDouble(
            PrefKeys.sessionTimeToleranceFraction,
          ),
          screenTimeFraction: prefs.getDouble(PrefKeys.screenTimeFraction),
          daysStreak: prefs.getInt(PrefKeys.daysStreak),
          waterDrops: prefs.getInt(PrefKeys.waterDrops),
          brightnessLevel: BrightnessLevel.values.byName(
            prefs.getString(PrefKeys.brightnessLevel) ??
                state.brightnessLevel.name,
          ),
          contrastLevel: ContrastLevel.values.byName(
            prefs.getString(PrefKeys.contrastLevel) ?? state.contrastLevel.name,
          ),
          useDynamicColors: prefs.getBool(PrefKeys.useDynamicColors),
          sessionTimeMax: Duration(
            minutes:
                prefs.getInt(PrefKeys.sessionTimeMax) ??
                state.sessionTimeMax.inMinutes,
          ),
          breakTimeMin: Duration(
            minutes:
                prefs.getInt(PrefKeys.breakTimeMin) ??
                state.breakTimeMin.inMinutes,
          ),
          screenTimeMax: Duration(
            minutes:
                prefs.getInt(PrefKeys.screenTimeMax) ??
                state.screenTimeMax.inMinutes,
          ),
          dailyResetTime: TimeOfDay(
            hour:
                prefs.getInt(PrefKeys.dailyResetHour) ??
                state.dailyResetTime.hour,
            minute:
                prefs.getInt(PrefKeys.dailyResetMinute) ??
                state.dailyResetTime.minute,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    foregroundService.dispose();
    super.close();
  }

  @override
  void navigateToSettings() {
    navigationService.navigateToSettings();
  }

  @override
  Future<void> initService() async {
    await foregroundService.init((Object data) {
      if (data is Map<String, dynamic>) {
        final sessionTimeFraction =
            data[PrefKeys.sessionTimeFraction] as double? ??
            Defaults.sessionTimeFraction;
        final sessionTimeToleranceFraction =
            data[PrefKeys.sessionTimeToleranceFraction] as double? ??
            Defaults.sessionTimeToleranceFraction;
        final screenTimeFraction =
            data[PrefKeys.screenTimeFraction] as double? ??
            Defaults.screenTimeFraction;
        final daysStreak = data[PrefKeys.daysStreak] as int? ??
            Defaults.daysStreak;
        final waterDrops = data[PrefKeys.waterDrops] as int? ??
            Defaults.waterDrops;
        emit(
          state.copyWith(
            sessionTimeFraction: sessionTimeFraction,
            screenTimeFraction: screenTimeFraction,
            sessionTimeToleranceFraction: sessionTimeToleranceFraction,
            daysStreak: daysStreak,
            waterDrops: waterDrops,
          ),
        );
      }
    });
  }

  @override
  void startService() async {
    final result = await foregroundService.start();
    if (result) {
      emit(state.copyWith(isServiceRunning: true));
    }
  }

  @override
  void stopService() async {
    final success = await foregroundService.stop();
    if (success) {
      emit(state.copyWith(isServiceRunning: false));
    }
  }

  @override
  void sendDataToService(Object data) {
    foregroundService.isRunning().then((isRunning) {
      if (isRunning) {
        foregroundService.sendDataToService(data);
      } else {
        debugPrint('Service is not running, cannot send data: $data');
      }
    });
  }

  @override
  void setBrightnessLevel(BrightnessLevel brightnessLevel) {
    prefs?.setString(PrefKeys.brightnessLevel, brightnessLevel.name);
    emit(state.copyWith(brightnessLevel: brightnessLevel));
  }

  @override
  void setContrastLevel(ContrastLevel contrastLevel) {
    prefs?.setString(PrefKeys.contrastLevel, contrastLevel.name);
    emit(state.copyWith(contrastLevel: contrastLevel));
  }

  @override
  void setUseDynamicColors(bool useDynamicColors) {
    prefs?.setBool(PrefKeys.useDynamicColors, useDynamicColors);
    emit(state.copyWith(useDynamicColors: useDynamicColors));
  }

  @override
  void setSessionTimeMax(Duration sessionTimeMax) {
    prefs?.setInt(PrefKeys.sessionTimeMax, sessionTimeMax.inMinutes);
    emit(state.copyWith(sessionTimeMax: sessionTimeMax));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setBreakTimeMin(Duration breakTimeMin) {
    prefs?.setInt(PrefKeys.breakTimeMin, breakTimeMin.inMinutes);
    emit(state.copyWith(breakTimeMin: breakTimeMin));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setScreenTimeMax(Duration screenTimeMax) {
    prefs?.setInt(PrefKeys.screenTimeMax, screenTimeMax.inMinutes);
    emit(state.copyWith(screenTimeMax: screenTimeMax));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setDailyResetTime(TimeOfDay dailyResetTime) {
    prefs?.setInt(PrefKeys.dailyResetHour, dailyResetTime.hour);
    prefs?.setInt(PrefKeys.dailyResetMinute, dailyResetTime.minute);
    emit(state.copyWith(dailyResetTime: dailyResetTime));
  }

  @override
  void reset() {
    foregroundService.stop();
    int daysStreak = state.daysStreak;
    int waterDrops = state.waterDrops;
    prefs?.clear();
    prefs?.setInt(PrefKeys.daysStreak, daysStreak);
    prefs?.setInt(PrefKeys.waterDrops, waterDrops);
    emit(BloomModel(daysStreak: daysStreak, waterDrops: waterDrops));
  }
}
