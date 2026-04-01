import 'package:injectable/injectable.dart';

import '../../../core/usecase.dart';
import '../domain/counter_load_result.dart';
import '../domain/counter_repository.dart';

/// 应用层用例；由 injectable 注册到 get_it（无需单独的 `@module` 工厂类）。
@lazySingleton
final class GetCounter implements UseCase<CounterLoadResult, NoParams> {
  GetCounter(this._repository);

  final CounterRepository _repository;

  @override
  Future<CounterLoadResult> call(NoParams _) => _repository.load();
}
