import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
final class RemoveFromCart extends UseCase<int, void> {
  RemoveFromCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Result<void>> execute(int cartItemId) async {
    await _repository.remove(cartItemId);
    return const Result.data(null);
  }
}
