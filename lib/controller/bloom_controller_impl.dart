import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:bloom_flutter/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloomControllerImpl extends Cubit<BloomModel> implements BloomController {
  final NavigationService navigationService;
  final ForegroundService foregroundService;
  final StorageService storageService;

  @override
  BloomControllerImpl({
    required this.navigationService,
    required this.foregroundService,
    required this.storageService,
  }) : super(BloomModel()) {
    // Load initial state from storage
    emit(
      state.copyWith(
        sessionTimeFraction: storageService.getDouble(
          PrefKeys.sessionTimeFraction,
        ),
        sessionTimeToleranceFraction: storageService.getDouble(
          PrefKeys.sessionTimeToleranceFraction,
        ),
        screenTimeFraction: storageService.getDouble(
          PrefKeys.screenTimeFraction,
        ),
        daysStreak: storageService.getInt(PrefKeys.daysStreak),
        waterDrops: storageService.getInt(PrefKeys.waterDrops),
        brightnessLevel: BrightnessLevel.values.byName(
          storageService.getString(PrefKeys.brightnessLevel) ??
              state.brightnessLevel.name,
        ),
        contrastLevel: ContrastLevel.values.byName(
          storageService.getString(PrefKeys.contrastLevel) ??
              state.contrastLevel.name,
        ),
        useDynamicColors: storageService.getBool(PrefKeys.useDynamicColors),
        sessionTimeMax: Duration(
          minutes:
              storageService.getInt(PrefKeys.sessionTimeMax) ??
              state.sessionTimeMax.inMinutes,
        ),
        breakTimeMin: Duration(
          minutes:
              storageService.getInt(PrefKeys.breakTimeMin) ??
              state.breakTimeMin.inMinutes,
        ),
        screenTimeMax: Duration(
          minutes:
              storageService.getInt(PrefKeys.screenTimeMax) ??
              state.screenTimeMax.inMinutes,
        ),
        dailyResetTime: TimeOfDay(
          hour:
              storageService.getInt(PrefKeys.dailyResetHour) ??
              state.dailyResetTime.hour,
          minute:
              storageService.getInt(PrefKeys.dailyResetMinute) ??
              state.dailyResetTime.minute,
        ),
      ),
    );
    // Initialize foreground service
    _initService();
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
    storageService.saveString(PrefKeys.brightnessLevel, brightnessLevel.name);
    emit(state.copyWith(brightnessLevel: brightnessLevel));
  }

  @override
  void setContrastLevel(ContrastLevel contrastLevel) {
    storageService.saveString(PrefKeys.contrastLevel, contrastLevel.name);
    emit(state.copyWith(contrastLevel: contrastLevel));
  }

  @override
  void setUseDynamicColors(bool useDynamicColors) {
    storageService.saveBool(PrefKeys.useDynamicColors, useDynamicColors);
    emit(state.copyWith(useDynamicColors: useDynamicColors));
  }

  @override
  void setSessionTimeMax(Duration sessionTimeMax) {
    storageService.saveInt(PrefKeys.sessionTimeMax, sessionTimeMax.inMinutes);
    emit(state.copyWith(sessionTimeMax: sessionTimeMax));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setBreakTimeMin(Duration breakTimeMin) {
    storageService.saveInt(PrefKeys.breakTimeMin, breakTimeMin.inMinutes);
    emit(state.copyWith(breakTimeMin: breakTimeMin));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setScreenTimeMax(Duration screenTimeMax) {
    storageService.saveInt(PrefKeys.screenTimeMax, screenTimeMax.inMinutes);
    emit(state.copyWith(screenTimeMax: screenTimeMax));
    sendDataToService(ActionData.timePrefsChanged);
  }

  @override
  void setDailyResetTime(TimeOfDay dailyResetTime) {
    storageService.saveInt(PrefKeys.dailyResetHour, dailyResetTime.hour);
    storageService.saveInt(PrefKeys.dailyResetMinute, dailyResetTime.minute);
    emit(state.copyWith(dailyResetTime: dailyResetTime));
  }

  @override
  void reset() {
    foregroundService.stop();
    int daysStreak = state.daysStreak;
    int waterDrops = state.waterDrops;
    storageService.clear().then((_) {
      storageService.saveInt(PrefKeys.daysStreak, daysStreak);
      storageService.saveInt(PrefKeys.waterDrops, waterDrops);
    });
    emit(BloomModel(daysStreak: daysStreak, waterDrops: waterDrops));
  }

  Future<void> _initService() async {
    await foregroundService.init((Object data) {
      if (data is Map<String, dynamic>) {
        final sessionTimeMillis =
            data[TransactionKeys.sessionTimeMillis] as int? ?? 0;
        final sessionTimeFraction =
            data[PrefKeys.sessionTimeFraction] as double?;
        final sessionTimeRemainingMillis =
            data[TransactionKeys.sessionTimeRemainingMillis] as int? ?? 0;
        final sessionTimeToleranceMillis =
            data[TransactionKeys.sessionTimeToleranceMillis] as int? ?? 0;
        final sessionTimeToleranceFraction =
            data[PrefKeys.sessionTimeToleranceFraction] as double?;
        final breakTimeMillis =
            data[TransactionKeys.breakTimeMillis] as int? ?? 0;
        final screenTimeMillis =
            data[TransactionKeys.screenTimeMillis] as int? ?? 0;
        final screenTimeFraction = data[PrefKeys.screenTimeFraction] as double?;
        final daysStreak = data[PrefKeys.daysStreak] as int?;
        final waterDrops = data[PrefKeys.waterDrops] as int?;
        emit(
          state.copyWith(
            sessionTime: Duration(milliseconds: sessionTimeMillis),
            sessionTimeFraction: sessionTimeFraction,
            sessionTimeRemaining: Duration(
              milliseconds: sessionTimeRemainingMillis,
            ),
            sessionTimeTolerance: Duration(
              milliseconds: sessionTimeToleranceMillis,
            ),
            sessionTimeToleranceFraction: sessionTimeToleranceFraction,
            breakTime: Duration(milliseconds: breakTimeMillis),
            screenTime: Duration(milliseconds: screenTimeMillis),
            screenTimeFraction: screenTimeFraction,
            daysStreak: daysStreak,
            waterDrops: waterDrops,
          ),
        );
      }
    });

    // Check if the service is running
    bool isRunning = await foregroundService.isRunning();
    emit(state.copyWith(isServiceRunning: isRunning));
  }
}
