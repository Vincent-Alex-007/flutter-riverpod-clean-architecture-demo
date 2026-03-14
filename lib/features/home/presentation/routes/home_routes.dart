import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_constant.dart';
import '../pages/home_screen.dart';

part 'home_routes.g.dart';

@TypedGoRoute<HomeRoute>(path: RouterPaths.home, name: RouterNames.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const CupertinoPage(child: HomeScreen());
}

final List<RouteBase> homeRoutes = $appRoutes;
