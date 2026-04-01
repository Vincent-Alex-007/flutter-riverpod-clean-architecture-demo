import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/router/router_constant.dart';
import '../pages/counter_demo_screen.dart';

part 'counter_routes.g.dart';

@TypedGoRoute<CounterDemoRoute>(
  path: RouterPaths.counterDemo,
  name: RouterNames.counterDemo,
)
class CounterDemoRoute extends GoRouteData with $CounterDemoRoute {
  const CounterDemoRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const CupertinoPage<void>(child: CounterDemoScreen());
}

final List<RouteBase> counterRoutes = $appRoutes;
