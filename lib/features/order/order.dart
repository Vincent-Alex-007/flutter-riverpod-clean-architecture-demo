/// Order 功能模块的**唯一对外入口**。
///
/// 购物车与下单功能，演示 Domain Service 复用与复杂 UseCase 编排。
library;

export 'presentation/providers/cart_riverpod.dart'
    show CartRiverpod, cartRiverpodProvider;
export 'presentation/routes/order_routes.dart' show CartRoute, orderRoutes;
