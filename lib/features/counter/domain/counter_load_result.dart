import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_load_result.freezed.dart';

/// 计数最近一次成功解析的来源（用于 UI 说明，无框架依赖）。
enum CounterValueSource {
  /// 来自模拟远程接口，并已（尝试）写回本地。
  remote,

  /// 远程不可用或失败时，使用本地持久化中的值。
  localFallback,
}

@freezed
class CounterLoadResult with _$CounterLoadResult {
  const CounterLoadResult({required this.value, required this.source});

  @override
  final int value;
  @override
  final CounterValueSource source;
}

enum InviteFailureType { format, invalid, empty }

@freezed
final class InviteCodeStatus with _$InviteCodeStatus {
  const factory InviteCodeStatus.success(String data) = _Success;
  const factory InviteCodeStatus.error(InviteFailureType type) = _Error;
}
