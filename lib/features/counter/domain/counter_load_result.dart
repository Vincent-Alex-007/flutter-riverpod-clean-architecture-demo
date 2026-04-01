/// 计数最近一次成功解析的来源（用于 UI 说明，无框架依赖）。
enum CounterValueSource {
  /// 来自模拟远程接口，并已（尝试）写回本地。
  remote,

  /// 远程不可用或失败时，使用本地持久化中的值。
  localFallback,
}

final class CounterLoadResult {
  const CounterLoadResult({
    required this.value,
    required this.source,
  });

  final int value;
  final CounterValueSource source;
}
