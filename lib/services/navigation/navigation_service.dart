import 'package:flutter/widgets.dart';

abstract class NavigationService {
  RouterConfig<Object> get router;

  void navigateToSettings();
}
