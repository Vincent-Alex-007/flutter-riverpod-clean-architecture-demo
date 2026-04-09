import '../entities/product_entity.dart';

/// 商品仓库接口
abstract interface class ProductRepository {
  /// 获取所有商品
  Future<List<ProductEntity>> getAll();

  /// 根据 ID 获取商品
  Future<ProductEntity> getById(int id);

  /// 扣减库存
  Future<void> reduceStock(int productId, int quantity);
}
