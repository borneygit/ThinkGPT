import 'package:app/src/features/home/desktop_home.dart';
import 'package:app/src/features/home/mobile_home.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

final router = isDesktop() ? _desktopRouter : _mobileRouter;

final _mobileRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const MobileHomeScreen()),
]);

final _desktopRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const DesktopHomeScreen()),
]);
