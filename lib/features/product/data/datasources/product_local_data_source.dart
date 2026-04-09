import '../../domain/entities/product_entity.dart';

/// 商品本地数据源接口
abstract interface class ProductLocalDataSource {
  Future<List<ProductEntity>> getAll();

  Future<ProductEntity> getById(int id);

  Future<void> reduceStock(int productId, int quantity);
}
