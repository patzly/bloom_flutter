import 'package:go_router/go_router.dart';
import 'navigation_service.dart';

class NavigationServiceImpl implements NavigationService {
  final GoRouter router;

  NavigationServiceImpl(this.router);

  @override
  void navigateToSettings() {
    router.push('/settings');
  }
}