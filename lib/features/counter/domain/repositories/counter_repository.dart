import '../entities/counter_load_result.dart';

/// 领域仓库：编排远程 + 本地，不暴露具体 IO 细节。
abstract interface class CounterRepository {
  /// 优先远程；失败则读本地缓存（可能为 null，按 0 展示）。
  Future<CounterLoadResult> load();

  /// 在「当前一致基数」上 +1：先尽量对齐远程/本地，再写本地并尝试推送远程。
  Future<CounterLoadResult> increment();
}
