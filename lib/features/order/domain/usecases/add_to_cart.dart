import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../repositories/cart_repository.dart';

/// 加入购物车参数
final class AddToCartParams {
  const AddToCartParams({required this.productId, required this.quantity});

  final int productId;
  final int quantity;
}

@lazySingleton
final class AddToCart extends UseCase<AddToCartParams, void> {
  AddToCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Result<void>> execute(AddToCartParams params) async {
    await _repository.add(params.productId, params.quantity);
    return const Result.data(null);
  }
}
