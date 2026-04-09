import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../domain/entities/price_breakdown.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/order_entity.dart';
import 'order_local_data_source.dart';

@LazySingleton(as: OrderLocalDataSource)
final class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  OrderLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<OrderEntity> create(PriceBreakdown breakdown) async {
    final id = await _db
        .into(_db.orders)
        .insert(
          OrdersCompanion.insert(
            subtotalInCents: breakdown.subtotalInCents,
            discountInCents: breakdown.discountInCents,
            taxInCents: breakdown.taxInCents,
            totalInCents: breakdown.totalInCents,
            status: const Value('completed'),
          ),
        );
    final row = await (_db.select(
      _db.orders,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toEntity(row);
  }

  @override
  Future<List<OrderEntity>> getAll() async {
    final rows = await (_db.select(
      _db.orders,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return rows.map(_toEntity).toList();
  }

  OrderEntity _toEntity(Order row) {
    return OrderEntity(
      id: row.id,
      subtotalInCents: row.subtotalInCents,
      discountInCents: row.discountInCents,
      taxInCents: row.taxInCents,
      totalInCents: row.totalInCents,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == row.status,
        orElse: () => OrderStatus.pending,
      ),
      createdAt: row.createdAt,
    );
  }
}
