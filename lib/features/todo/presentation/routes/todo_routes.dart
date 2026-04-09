import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/router/router_constant.dart';
import '../pages/todo_screen.dart';

part 'todo_routes.g.dart';

@TypedGoRoute<TodoDemoRoute>(
  path: RouterPaths.todoDemo,
  name: RouterNames.todoDemo,
)
class TodoDemoRoute extends GoRouteData with $TodoDemoRoute {
  const TodoDemoRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const CupertinoPage<void>(child: TodoScreen());
}

final List<RouteBase> todoRoutes = $appRoutes;
