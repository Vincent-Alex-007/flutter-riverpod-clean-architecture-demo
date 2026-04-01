import 'package:injectable/injectable.dart';

import '../domain/counter_load_result.dart';
import '../domain/counter_local_data_source.dart';
import '../domain/counter_remote_data_source.dart';
import '../domain/counter_repository.dart';

/// 基础设施仓库：远程优先加载；自增时先对齐基数再写本地并尝试推送远程。
@LazySingleton(as: CounterRepository)
final class CounterRepositoryImpl implements CounterRepository {
  CounterRepositoryImpl(this._remote, this._local);

  final CounterRemoteDataSource _remote;
  final CounterLocalDataSource _local;

  @override
  Future<CounterLoadResult> load() async {
    try {
      final remote = await _remote.fetchCounter();
      await _local.writeCounter(remote);
      return CounterLoadResult(
        value: remote,
        source: CounterValueSource.remote,
      );
    } on Object catch (_) {
      final cached = await _local.readCounter();
      return CounterLoadResult(
        value: cached ?? 0,
        source: CounterValueSource.localFallback,
      );
    }
  }

  @override
  Future<CounterLoadResult> increment() async {
    final base = await _resolveBaseForIncrement();
    final next = base + 1;
    await _local.writeCounter(next);
    try {
      await _remote.pushCounter(next);
      return CounterLoadResult(
        value: next,
        source: CounterValueSource.remote,
      );
    } on Object catch (_) {
      return CounterLoadResult(
        value: next,
        source: CounterValueSource.localFallback,
      );
    }
  }

  /// 自增前对齐：优先远程；失败则用本地；都无则 0。
  Future<int> _resolveBaseForIncrement() async {
    try {
      final remote = await _remote.fetchCounter();
      await _local.writeCounter(remote);
      return remote;
    } on Object catch (_) {
      return (await _local.readCounter()) ?? 0;
    }
  }
}
