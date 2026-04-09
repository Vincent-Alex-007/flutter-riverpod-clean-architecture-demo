import '../../domain/entities/cart_item_entity.dart';

/// 购物车本地数据源接口
abstract interface class CartLocalDataSource {
  /// 获取购物车所有项（JOIN 商品表获取名称和价格）
  Future<List<CartItemEntity>> getAll();

  /// 添加商品（已存在则累加数量）
  Future<void> add(int productId, int quantity);

  /// 移除购物车项
  Future<void> remove(int cartItemId);

  /// 清空购物车
  Future<void> clear();
}
