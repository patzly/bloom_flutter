import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'navigation_service.dart';

class NavigationServiceImpl implements NavigationService {
  final BuildContext context;

  NavigationServiceImpl(this.context);

  @override
  void navigateToSettings() {
    context.push('/settings');
  }
}