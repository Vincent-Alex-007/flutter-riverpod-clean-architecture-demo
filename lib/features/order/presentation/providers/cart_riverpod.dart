import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/price_breakdown.dart';
import '../../../../infrastructure/di/injection.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/preview_order.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/submit_order.dart';

part 'cart_riverpod.g.dart';

/// 购物车状态管理
@riverpod
class CartRiverpod extends _$CartRiverpod {
  @override
  FutureOr<List<CartItemEntity>> build() async {
    final result = await getIt<GetCart>().call();
    return result.value ?? [];
  }

  /// 加入购物车
  Future<void> addToCart(int productId, int quantity) async {
    await getIt<AddToCart>().call(
      AddToCartParams(productId: productId, quantity: quantity),
    );
    ref.invalidateSelf();
  }

  /// 移除购物车项
  Future<void> remove(int cartItemId) async {
    await getIt<RemoveFromCart>().call(cartItemId);
    ref.invalidateSelf();
  }
}

/// 订单价格预览状态（依赖购物车数据）
@riverpod
class OrderPreviewRiverpod extends _$OrderPreviewRiverpod {
  @override
  FutureOr<PriceBreakdown?> build() async {
    // 监听购物车变化，自动重新计算价格
    final cartAsync = ref.watch(cartRiverpodProvider);
    final cart = cartAsync.value;
    if (cart == null || cart.isEmpty) return null;

    final result = await getIt<PreviewOrder>().call();
    return result.value;
  }
}

/// 提交订单状态
@riverpod
class SubmitOrderRiverpod extends _$SubmitOrderRiverpod {
  @override
  FutureOr<OrderSubmitResult?> build() => null;

  /// 提交订单
  Future<void> submit() async {
    state = const AsyncValue.loading();
    final result = await getIt<SubmitOrder>().call();
    state = result.hasData
        ? AsyncValue.data(result.value)
        : AsyncValue.error(result.error!, result.stackTrace!);
  }
}
