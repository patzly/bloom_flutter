import 'package:bloom_flutter/screens/home/controller/home_controller.dart';
import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class HomeControllerImpl extends Cubit<HomeModel> implements HomeController {
  final NavigationService navigationService;

  @override
  HomeControllerImpl({required this.navigationService})
      : super(
    HomeModel(
      sessionTime: const Duration(minutes: 15),
      screenTime: const Duration(minutes: 30),
      exceededTime: const Duration(minutes: 2, seconds: 35),
    ),
  ) {
    FlutterForegroundTask.isRunningService.then((value) {
      emit(state.copyWith(isServiceRunning: value));
    });
  }

  @override
  void navigateToSettings() {
    navigationService.navigateToSettings();
  }

  @override
  Future<void> startService() async {
    final result = await FlutterForegroundTask.startService(notificationTitle: "hello", notificationText: "hello");
    if (result is ServiceRequestSuccess) {
      emit(state.copyWith(isServiceRunning: true));
    } else if (result is ServiceRequestFailure) {
      debugPrint('Error starting the service: ${result.error}');
    }
  }

  @override
  Future<void> stopService() async {
    final result = await FlutterForegroundTask.stopService();
    if (result is ServiceRequestSuccess) {
      emit(state.copyWith(isServiceRunning: false));
    } else if (result is ServiceRequestFailure) {
      debugPrint('Error stopping the service: ${result.error}');
    }
  }
}
