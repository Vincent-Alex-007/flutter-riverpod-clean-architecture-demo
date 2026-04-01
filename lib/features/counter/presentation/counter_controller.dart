import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/usecase.dart';
import '../../../infrastructure/di/injection.dart';
import '../application/get_counter.dart';
import '../application/increment_counter.dart';
import '../domain/counter_load_result.dart';

part 'counter_controller.g.dart';

/// 表现层：Riverpod 承载 [CounterLoadResult]；用例由 get_it 解析。
@riverpod
class CounterDemo extends _$CounterDemo {
  @override
  Future<CounterLoadResult> build() =>
      getIt<GetCounter>()(const NoParams());

  Future<void> increment() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => getIt<IncrementCounter>()(const NoParams()),
    );
  }

  /// 再次走「加载」用例（远程优先 + 本地兜底），用于下拉刷新等。
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => getIt<GetCounter>()(const NoParams()),
    );
  }
}
