import 'package:injectable/injectable.dart';

import '../../../core/usecase.dart';
import '../domain/counter_load_result.dart';
import '../domain/counter_repository.dart';

@lazySingleton
final class IncrementCounter implements UseCase<CounterLoadResult, NoParams> {
  IncrementCounter(this._repository);

  final CounterRepository _repository;

  @override
  Future<CounterLoadResult> call(NoParams _) => _repository.increment();
}
