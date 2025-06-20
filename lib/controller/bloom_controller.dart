import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BloomController extends Cubit<BloomModel> {
  BloomController(super.initialState);

  void dispose() {
    super.close();
  }

  void navigateToSettings();

  Future<void> initService();

  void startService();

  void stopService();
}
