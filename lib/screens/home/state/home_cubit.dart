import 'package:bloc/bloc.dart';
import 'package:bloom_flutter/screens/home/state/home_state.dart';
import 'package:bloom_flutter/services/settings_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final SettingsService _settingsService;

  HomeCubit(this._settingsService) : super(HomeLoading()) {
    loadData();
  }

  void loadData() async {
    try {
      emit(HomeLoading());
      final model = await _settingsService.fetchHomeData();
      emit(HomeLoaded(model));
    } catch (e) {
      emit(HomeError("Daten konnten nicht geladen werden."));
    }
  }
}
