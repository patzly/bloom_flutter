import 'package:bloom_flutter/screens/home/event/home_event.dart';
import 'package:bloom_flutter/screens/home/state/home_state.dart';
import 'package:bloom_flutter/services/settings_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ISettingsService service;

  HomeBloc(this.service) : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      final model = await service.fetchHomeData();
      emit(HomeLoaded(model));
    });
  }
}