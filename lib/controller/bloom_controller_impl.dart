import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloomControllerImpl extends Cubit<BloomModel> implements BloomController {
  final NavigationService navigationService;
  final PhoneTimeService phoneTimeService;

  @override
  BloomControllerImpl({
    required this.navigationService,
    required this.phoneTimeService,
  }) : super(
         BloomModel(
           sessionTime: const Duration(minutes: 15),
           screenTime: const Duration(minutes: 30),
           exceededTime: const Duration(minutes: 2, seconds: 35),
         ),
       ) {
    phoneTimeService.isRunning().then((value) {
      emit(state.copyWith(isServiceRunning: value));
    });
  }

  @override
  void dispose() {
    phoneTimeService.dispose();
    super.close();
  }

  @override
  void navigateToSettings() {
    navigationService.navigateToSettings();
  }

  @override
  Future<void> initService() async {
    await phoneTimeService.init((Object data) {
      if (data is Map<String, dynamic>) {
        final timestampMillis = data["timestampMillis"];
        if (timestampMillis != null) {
          final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
            timestampMillis as int,
            isUtc: true,
          );
          print('timestamp: ${timestamp.toString()}');
        }
      }
    });
  }

  @override
  void startService() async {
    final result = await phoneTimeService.start();
    if (result) {
      emit(state.copyWith(isServiceRunning: true));
    }
  }

  @override
  void stopService() async {
    final success = await phoneTimeService.stop();
    if (success) {
      emit(state.copyWith(isServiceRunning: false));
    }
  }
}
