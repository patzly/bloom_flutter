import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BloomController extends Cubit<BloomModel> {
  BloomController(super.initialState);

  void navigateToSettings();
  void startService();
  void stopService();
}
