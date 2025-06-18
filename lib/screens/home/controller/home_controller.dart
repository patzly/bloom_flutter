import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeController extends Cubit<HomeModel> {
  HomeController(super.initialState);

  void navigateToSettings();
}
