import 'package:bloom_flutter/routes/bloom_routes.dart';
import 'package:bloom_flutter/screens/home/home_screen.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'navigation_service.dart';

class NavigationServiceImpl implements NavigationService {
  final GoRouter _router = GoRouter(
    initialLocation: BloomRoutes.home,
    routes: [
      GoRoute(
        path: BloomRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: BloomRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  @override
  RouterConfig<Object> get router => _router;

  @override
  void navigateToSettings() {
    _router.push(BloomRoutes.settings);
  }
}
