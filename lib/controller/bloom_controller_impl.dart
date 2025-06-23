import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloomControllerImpl extends Cubit<BloomModel> implements BloomController {
  final NavigationService navigationService;
  final ForegroundService foregroundService;

  @override
  BloomControllerImpl({
    required this.navigationService,
    required this.foregroundService,
  }) : super(
         BloomModel(
           sessionTime: const Duration(minutes: 15),
           screenTime: const Duration(minutes: 30),
           exceededTime: const Duration(minutes: 2, seconds: 35),
         ),
       ) {
    foregroundService.isRunning().then((value) {
      emit(state.copyWith(isServiceRunning: value));
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
        final timestampMillis = data["timestampMillis"];
        if (timestampMillis != null) {
          final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
            timestampMillis as int,
            isUtc: true,
          );
          emit(
            state.copyWith(
              sessionTime: state.sessionTime + Duration(seconds: 1),
            ),
          );
        }
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
}
