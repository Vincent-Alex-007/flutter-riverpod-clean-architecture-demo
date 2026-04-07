import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/counter_load_result.dart';
import '../repositories/counter_repository.dart';

@lazySingleton
final class GetCounter extends NoParamsUseCase<CounterLoadResult> {
  GetCounter(this._repository);

  final CounterRepository _repository;

  @override
  Future<Result<CounterLoadResult>> execute() async {
    return Result.data(await _repository.load());
  }
}
