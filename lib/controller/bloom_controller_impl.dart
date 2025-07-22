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
      final brightnessLevel =
          prefs.getString(PrefKeys.brightnessLevel) ??
          Defaults.brightnessLevel.name;
      final contrastLevel =
          prefs.getString(PrefKeys.contrastLevel) ??
          Defaults.contrastLevel.name;
      final useDynamicColors =
          prefs.getBool(PrefKeys.useDynamicColors) ?? Defaults.useDynamicColors;
      final sessionTimeMax = Duration(
        minutes:
            prefs.getInt(PrefKeys.sessionTimeMax) ??
            Defaults.sessionTimeMax.inMinutes,
      );
      final breakTimeMin = Duration(
        minutes:
            prefs.getInt(PrefKeys.breakTimeMin) ??
            Defaults.breakTimeMin.inMinutes,
      );
      final screenTimeMax = Duration(
        minutes:
            prefs.getInt(PrefKeys.screenTimeMax) ??
            Defaults.screenTimeMax.inMinutes,
      );
      final dailyResetTime = TimeOfDay(
        hour:
            prefs.getInt(PrefKeys.dailyResetHour) ??
            Defaults.dailyResetTime.hour,
        minute:
            prefs.getInt(PrefKeys.dailyResetMinute) ??
            Defaults.dailyResetTime.minute,
      );
      emit(
        state.copyWith(
          brightnessLevel: BrightnessLevel.values.byName(brightnessLevel),
          contrastLevel: ContrastLevel.values.byName(contrastLevel),
          useDynamicColors: useDynamicColors,
          sessionTimeMax: sessionTimeMax,
          breakTimeMin: breakTimeMin,
          screenTimeMax: screenTimeMax,
          dailyResetTime: dailyResetTime,
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
        emit(
          state.copyWith(
            sessionTimeFraction: sessionTimeFraction,
            screenTimeFraction: screenTimeFraction,
            sessionTimeToleranceFraction: sessionTimeToleranceFraction,
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
  }

  @override
  void setBreakTimeMin(Duration breakTimeMin) {
    prefs?.setInt(PrefKeys.breakTimeMin, breakTimeMin.inMinutes);
    emit(state.copyWith(breakTimeMin: breakTimeMin));
  }

  @override
  void setScreenTimeMax(Duration screenTimeMax) {
    prefs?.setInt(PrefKeys.screenTimeMax, screenTimeMax.inMinutes);
    emit(state.copyWith(screenTimeMax: screenTimeMax));
  }

  @override
  void setDailyResetTime(TimeOfDay dailyResetTime) {
    prefs?.setInt(PrefKeys.dailyResetHour, dailyResetTime.hour);
    prefs?.setInt(PrefKeys.dailyResetMinute, dailyResetTime.minute);
    emit(state.copyWith(dailyResetTime: dailyResetTime));
  }
}
