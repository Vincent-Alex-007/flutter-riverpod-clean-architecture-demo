import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_entity.freezed.dart';

/// 订单状态
enum OrderStatus { pending, completed, cancelled }

/// 订单领域实体
@freezed
class OrderEntity with _$OrderEntity {
  const OrderEntity({
    required this.id,
    required this.subtotalInCents,
    required this.discountInCents,
    required this.taxInCents,
    required this.totalInCents,
    required this.status,
    required this.createdAt,
  });

  @override
  final int id;
  @override
  final int subtotalInCents;
  @override
  final int discountInCents;
  @override
  final int taxInCents;
  @override
  final int totalInCents;
  @override
  final OrderStatus status;
  @override
  final DateTime createdAt;
}
