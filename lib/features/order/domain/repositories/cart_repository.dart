import '../entities/cart_item_entity.dart';

/// 购物车仓库接口
abstract interface class CartRepository {
  /// 获取购物车所有项（含商品信息）
  Future<List<CartItemEntity>> getAll();

  /// 添加商品到购物车（已存在则累加数量）
  Future<void> add(int productId, int quantity);

  /// 移除购物车中某项
  Future<void> remove(int cartItemId);

  /// 清空购物车
  Future<void> clear();
}
