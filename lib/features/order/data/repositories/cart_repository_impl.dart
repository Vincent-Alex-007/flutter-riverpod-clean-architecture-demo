import 'package:injectable/injectable.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

@LazySingleton(as: CartRepository)
final class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._local);

  final CartLocalDataSource _local;

  @override
  Future<List<CartItemEntity>> getAll() => _local.getAll();

  @override
  Future<void> add(int productId, int quantity) =>
      _local.add(productId, quantity);

  @override
  Future<void> remove(int cartItemId) => _local.remove(cartItemId);

  @override
  Future<void> clear() => _local.clear();
}
