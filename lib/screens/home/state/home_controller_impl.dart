import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:bloom_flutter/screens/home/state/home_controller.dart';
import 'package:bloom_flutter/services/navigation/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ) {}

  @override
  void navigateToSettings() {
    navigationService.navigateToSettings();
  }
}
