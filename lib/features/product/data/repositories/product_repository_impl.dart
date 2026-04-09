import 'package:injectable/injectable.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

@LazySingleton(as: ProductRepository)
final class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._local);

  final ProductLocalDataSource _local;

  @override
  Future<List<ProductEntity>> getAll() => _local.getAll();

  @override
  Future<ProductEntity> getById(int id) => _local.getById(id);

  @override
  Future<void> reduceStock(int productId, int quantity) =>
      _local.reduceStock(productId, quantity);
}
