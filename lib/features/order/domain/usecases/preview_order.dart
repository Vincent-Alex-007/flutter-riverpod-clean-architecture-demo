import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/price_breakdown.dart';
import '../repositories/cart_repository.dart';
import '../services/pricing_service.dart';

/// 预览订单价格（不产生副作用）
///
/// 演示 Domain Service 复用：PreviewOrder 和 SubmitOrder 共享 PricingService。
@lazySingleton
final class PreviewOrder extends NoParamsUseCase<PriceBreakdown> {
  PreviewOrder(this._cartRepo, this._pricingService);

  final CartRepository _cartRepo;
  final PricingService _pricingService;

  @override
  Future<Result<PriceBreakdown>> execute() async {
    final items = await _cartRepo.getAll();

    final lineItems = items
        .map(
          (e) =>
              PriceLineItem(priceInCents: e.priceInCents, quantity: e.quantity),
        )
        .toList();

    return Result.data(_pricingService.calculate(lineItems));
  }
}
