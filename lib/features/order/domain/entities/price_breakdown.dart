import '../../../../core/utils/currency_format.dart';

/// 价格计算结果值对象
///
/// 由 PricingService 生成，被 repository、use case、presentation 各层引用。
final class PriceBreakdown {
  const PriceBreakdown({
    required this.subtotalInCents,
    required this.discountInCents,
    required this.taxInCents,
    required this.totalInCents,
    required this.discountReason,
  });

  final int subtotalInCents;
  final int discountInCents;
  final int taxInCents;
  final int totalInCents;

  /// 折扣说明，为空表示无折扣
  final String? discountReason;

  /// 格式化金额（分 → 元），委托给 core 通用工具
  static String format(int cents) => formatCents(cents);
}
