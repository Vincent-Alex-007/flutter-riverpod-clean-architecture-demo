import '../../domain/entities/price_breakdown.dart';
import '../../domain/entities/order_entity.dart';

/// 订单本地数据源接口
abstract interface class OrderLocalDataSource {
  Future<OrderEntity> create(PriceBreakdown breakdown);

  Future<List<OrderEntity>> getAll();
}
