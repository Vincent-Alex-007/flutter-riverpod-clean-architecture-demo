import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

/// 商品领域实体
@freezed
class ProductEntity with _$ProductEntity {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.stock,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int priceInCents;
  @override
  final int stock;
}
