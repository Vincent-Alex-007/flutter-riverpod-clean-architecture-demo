import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';

part 'product_riverpod.g.dart';

/// 商品列表状态管理
@riverpod
class ProductRiverpod extends _$ProductRiverpod {
  @override
  FutureOr<List<ProductEntity>> build() async {
    final result = await getIt<GetProducts>().call();
    return result.value ?? [];
  }

  /// 刷新商品列表
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
