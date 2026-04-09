import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../entities/price_breakdown.dart';
import '../repositories/cart_repository.dart';
import '../repositories/order_repository.dart';
import '../services/pricing_service.dart';

/// 提交订单 — 复杂 UseCase 编排示例
///
/// 流程：
/// 1. 获取购物车 → 校验非空
/// 2. 校验库存充足
/// 3. 调用 Domain Service（PricingService）计算价格
/// 4. 创建订单记录
/// 5. 扣减库存
/// 6. 清空购物车
///
/// 演示要点：
/// - UseCase 编排多个 Repository + Domain Service
/// - 跨 feature 依赖：通过 ProductRepository 接口（非直接依赖 product 的 data 层）
/// - Domain Service 复用：与 PreviewOrder 共享 PricingService
@lazySingleton
final class SubmitOrder extends NoParamsUseCase<OrderSubmitResult> {
  SubmitOrder(
    this._cartRepo,
    this._orderRepo,
    this._productRepo,
    this._pricingService,
  );

  final CartRepository _cartRepo;
  final OrderRepository _orderRepo;
  final ProductRepository _productRepo;
  final PricingService _pricingService;

  @override
  Future<Result<OrderSubmitResult>> execute() async {
    // 1. 获取购物车
    final cartItems = await _cartRepo.getAll();
    if (cartItems.isEmpty) {
      throw const BusinessException(message: '购物车为空，无法下单');
    }

    // 2. 校验库存
    for (final item in cartItems) {
      final product = await _productRepo.getById(item.productId);
      if (product.stock < item.quantity) {
        throw BusinessException(
          message:
              '「${product.name}」库存不足（剩余 ${product.stock}，需要 ${item.quantity}）',
        );
      }
    }

    // 3. Domain Service 计算价格
    final lineItems = cartItems
        .map(
          (e) =>
              PriceLineItem(priceInCents: e.priceInCents, quantity: e.quantity),
        )
        .toList();
    final breakdown = _pricingService.calculate(lineItems);

    // 4. 创建订单
    final order = await _orderRepo.create(breakdown);

    // 5. 扣减库存
    for (final item in cartItems) {
      await _productRepo.reduceStock(item.productId, item.quantity);
    }

    // 6. 清空购物车
    await _cartRepo.clear();

    return Result.data(
      OrderSubmitResult(
        orderId: order.id,
        breakdown: breakdown,
        itemCount: cartItems.length,
      ),
    );
  }
}

/// 下单结果
final class OrderSubmitResult {
  const OrderSubmitResult({
    required this.orderId,
    required this.breakdown,
    required this.itemCount,
  });

  final int orderId;
  final PriceBreakdown breakdown;
  final int itemCount;
}
