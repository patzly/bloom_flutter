import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
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
      final contrastLevel =
          prefs.getString(PrefKeys.contrastLevel) ??
          Defaults.contrastLevel.name;
      print(contrastLevel);
      emit(
        state.copyWith(
          contrastLevel: ContrastLevel.values.byName(contrastLevel),
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
        print(
          'Foreground service data received: sessionTimeFraction=$sessionTimeFraction, screenTimeFraction=$screenTimeFraction, sessionTimeToleranceFraction=$sessionTimeToleranceFraction',
        );
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
  void setContrastLevel(ContrastLevel contrastLevel) {
    prefs?.setString(PrefKeys.contrastLevel, contrastLevel.name);
    emit(state.copyWith(contrastLevel: contrastLevel));
  }
}
