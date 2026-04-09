import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_entity.freezed.dart';

/// 购物车项领域实体（包含关联的商品信息，方便展示）
@freezed
class CartItemEntity with _$CartItemEntity {
  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.priceInCents,
    required this.quantity,
  });

  @override
  final int id;
  @override
  final int productId;
  @override
  final String productName;

  /// 商品单价（分）
  @override
  final int priceInCents;
  @override
  final int quantity;
}
