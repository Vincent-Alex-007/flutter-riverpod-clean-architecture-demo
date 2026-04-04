import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../application/get_counter.dart';
import '../../application/increment_counter.dart';
import '../../domain/counter_load_result.dart';

part 'counter_riverpod.g.dart';

/// 表现层：Riverpod 承载 [CounterLoadResult]；用例由 get_it 解析。
@riverpod
class CounterRiverpod extends _$CounterRiverpod {
  @override
  FutureOr<CounterLoadResult?> build() async {
    final result = await getIt<GetCounter>().call();
    return result.value;
  }

  /// 增加计数器
  Future<void> increment() async {
    state = const AsyncValue.loading();
    final result = await getIt<IncrementCounter>().call();

    // result.when(
    //   data: (data) => state = AsyncValue.data(data),
    //   err: (err, stackTrace) => state = AsyncValue.error(err, stackTrace),
    // );

    // final newResult = await result.mapOrNull(
    //   data: (data) async => await getIt<GetCounter>().call(),
    // );
  }

  /// 再次走「加载」用例（远程优先 + 本地兜底），用于下拉刷新等。
  Future<void> reload() async {
    state = const AsyncValue.loading();
    final result = await getIt<GetCounter>().call();
    // state = AsyncValue.data(result.dataOrNull);
  }
}
