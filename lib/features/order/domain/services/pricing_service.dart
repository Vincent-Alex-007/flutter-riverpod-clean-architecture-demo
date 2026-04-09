import 'package:injectable/injectable.dart';

import '../entities/price_breakdown.dart';

/// 价格行项目输入
final class PriceLineItem {
  const PriceLineItem({required this.priceInCents, required this.quantity});

  final int priceInCents;
  final int quantity;
}

/// Domain Service：定价计算
///
/// 纯业务规则，无 IO 操作，不依赖任何 Repository。
/// 可被多个 UseCase（预览订单、提交订单）复用。
///
/// 规则：
/// - 满 50 元（5000 分）打 95 折
/// - 满 100 元（10000 分）打 9 折
/// - 满 200 元（20000 分）打 85 折
/// - 税率 6%
@lazySingleton
final class PricingService {
  static const _taxRate = 0.06;

  PriceBreakdown calculate(List<PriceLineItem> items) {
    // 1. 计算小计
    final subtotal = items.fold<int>(
      0,
      (sum, item) => sum + item.priceInCents * item.quantity,
    );

    // 2. 计算折扣
    final (discountCents, reason) = _calculateDiscount(subtotal);

    // 3. 折后金额
    final afterDiscount = subtotal - discountCents;

    // 4. 税费（向下取整）
    final tax = (afterDiscount * _taxRate).floor();

    // 5. 总计
    final total = afterDiscount + tax;

    return PriceBreakdown(
      subtotalInCents: subtotal,
      discountInCents: discountCents,
      taxInCents: tax,
      totalInCents: total,
      discountReason: reason,
    );
  }

  (int cents, String? reason) _calculateDiscount(int subtotalInCents) {
    if (subtotalInCents >= 20000) {
      final discount = (subtotalInCents * 0.15).floor();
      return (discount, '满 200 元享 85 折');
    }
    if (subtotalInCents >= 10000) {
      final discount = (subtotalInCents * 0.10).floor();
      return (discount, '满 100 元享 9 折');
    }
    if (subtotalInCents >= 5000) {
      final discount = (subtotalInCents * 0.05).floor();
      return (discount, '满 50 元享 95 折');
    }
    return (0, null);
  }
}
