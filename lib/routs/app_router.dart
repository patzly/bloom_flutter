
import 'package:go_router/go_router.dart';
import 'bloom_routs.dart';
import 'package:bloom_flutter/screens/home/home_screen.dart';
import 'package:bloom_flutter/screens/settings/settings_screen.dart';

class app_routs {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: bloom_routs.home,
      routes: [
        GoRoute(
          path: bloom_routs.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: bloom_routs.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}
