import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/router/router_constant.dart';
import '../pages/cart_screen.dart';

part 'order_routes.g.dart';

@TypedGoRoute<CartRoute>(
  path: RouterPaths.cart,
  name: RouterNames.cart,
)
class CartRoute extends GoRouteData with $CartRoute {
  const CartRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const CupertinoPage<void>(child: CartScreen());
}

final List<RouteBase> orderRoutes = $appRoutes;
