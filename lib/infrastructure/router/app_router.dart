import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../features/counter/counter.dart';
import '../../features/home/home.dart';
import '../../features/todo/todo.dart';

final List<RouteBase> appRoutes = [...homeRoutes, ...counterRoutes, ...todoRoutes];

GoRouter createAppRouter(Talker talker) {
  return GoRouter(routes: appRoutes, observers: [TalkerRouteObserver(talker)]);
}
