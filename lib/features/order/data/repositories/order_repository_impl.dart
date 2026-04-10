import 'package:injectable/injectable.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/price_breakdown.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';

@LazySingleton(as: OrderRepository)
final class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._local);

  final OrderLocalDataSource _local;

  @override
  Future<OrderEntity> create(PriceBreakdown breakdown) =>
      _local.create(breakdown);

  @override
  Future<List<OrderEntity>> getAll() => _local.getAll();
}
