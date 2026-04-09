import '../entities/price_breakdown.dart';
import '../entities/order_entity.dart';

/// 订单仓库接口
abstract interface class OrderRepository {
  /// 创建订单记录
  Future<OrderEntity> create(PriceBreakdown breakdown);

  /// 获取历史订单
  Future<List<OrderEntity>> getAll();
}
