import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@lazySingleton
final class GetProducts extends NoParamsUseCase<List<ProductEntity>> {
  GetProducts(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<List<ProductEntity>>> execute() async {
    return Result.data(await _repository.getAll());
  }
}
