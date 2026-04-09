import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/product_entity.dart';
import 'product_local_data_source.dart';

@LazySingleton(as: ProductLocalDataSource)
final class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<ProductEntity>> getAll() async {
    final rows = await (_db.select(
      _db.products,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<ProductEntity> getById(int id) async {
    final row = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toEntity(row);
  }

  @override
  Future<void> reduceStock(int productId, int quantity) async {
    final row = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(productId))).getSingle();
    await (_db.update(_db.products)..where((t) => t.id.equals(productId)))
        .write(ProductsCompanion(stock: Value(row.stock - quantity)));
  }

  ProductEntity _toEntity(Product row) {
    return ProductEntity(
      id: row.id,
      name: row.name,
      description: row.description,
      priceInCents: row.priceInCents,
      stock: row.stock,
    );
  }
}
