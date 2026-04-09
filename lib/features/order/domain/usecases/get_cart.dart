import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
final class GetCart extends NoParamsUseCase<List<CartItemEntity>> {
  GetCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Result<List<CartItemEntity>>> execute() async {
    return Result.data(await _repository.getAll());
  }
}
