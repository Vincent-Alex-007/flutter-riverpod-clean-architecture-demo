import 'package:injectable/injectable.dart';

import '../../../core/result.dart';
import '../../../core/usecase.dart';
import '../domain/counter_load_result.dart';
import '../domain/counter_repository.dart';

@lazySingleton
final class IncrementCounter extends NoParamsUseCase<CounterLoadResult> {
  IncrementCounter(this._repository);

  final CounterRepository _repository;

  @override
  Future<Result<CounterLoadResult>> execute() async {
    return Result.success(await _repository.increment());
  }
}
