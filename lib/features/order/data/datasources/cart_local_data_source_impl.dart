import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_local_data_source.dart';

@LazySingleton(as: CartLocalDataSource)
final class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<CartItemEntity>> getAll() async {
    // JOIN 商品表，获取名称和单价
    final query = _db.select(_db.cartItems).join([
      innerJoin(
        _db.products,
        _db.products.id.equalsExp(_db.cartItems.productId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) {
      final cart = row.readTable(_db.cartItems);
      final product = row.readTable(_db.products);
      return CartItemEntity(
        id: cart.id,
        productId: cart.productId,
        productName: product.name,
        priceInCents: product.priceInCents,
        quantity: cart.quantity,
      );
    }).toList();
  }

  @override
  Future<void> add(int productId, int quantity) async {
    // 查找是否已存在该商品
    final existing = await (_db.select(
      _db.cartItems,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();

    if (existing != null) {
      // 累加数量
      await (_db.update(
        _db.cartItems,
      )..where((t) => t.id.equals(existing.id))).write(
        CartItemsCompanion(quantity: Value(existing.quantity + quantity)),
      );
    } else {
      await _db
          .into(_db.cartItems)
          .insert(
            CartItemsCompanion.insert(
              productId: productId,
              quantity: Value(quantity),
            ),
          );
    }
  }

  @override
  Future<void> remove(int cartItemId) async {
    await (_db.delete(
      _db.cartItems,
    )..where((t) => t.id.equals(cartItemId))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.cartItems).go();
  }
}
