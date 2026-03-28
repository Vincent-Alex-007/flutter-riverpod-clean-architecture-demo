import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../features/home/home.dart';
import '../di/injection.dart';

final List<RouteBase> appRoutes = [...homeRoutes];

GoRouter createAppRouter() {
  return GoRouter(
    routes: appRoutes,
    observers: [TalkerRouteObserver(getIt<Talker>())],
  );
}
