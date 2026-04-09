import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/router/router_constant.dart';
import '../pages/product_list_screen.dart';

part 'product_routes.g.dart';

@TypedGoRoute<ProductListRoute>(
  path: RouterPaths.productList,
  name: RouterNames.productList,
)
class ProductListRoute extends GoRouteData with $ProductListRoute {
  const ProductListRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const CupertinoPage<void>(child: ProductListScreen());
}

final List<RouteBase> productRoutes = $appRoutes;
