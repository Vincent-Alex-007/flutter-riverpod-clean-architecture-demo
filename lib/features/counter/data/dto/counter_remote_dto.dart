import 'package:json_annotation/json_annotation.dart';

part 'counter_remote_dto.g.dart';

/// 远程接口的 **data** 载荷（与后端 JSON 字段一一对应）。
///
/// 放在 `data/dto`：属于「线格式 / 反序列化」细节，**不进入 domain**。
/// 领域只通过 [CounterRemoteDataSource] 拿到已解析的标量或领域结果。
@JsonSerializable()
class CounterCountDataDto {
  const CounterCountDataDto({required this.count});

  factory CounterCountDataDto.fromJson(Map<String, dynamic> json) =>
      _$CounterCountDataDtoFromJson(json);

  final int count;

  Map<String, dynamic> toJson() => _$CounterCountDataDtoToJson(this);
}

/// 模拟 PUT/POST 请求体（与真实 API body 对齐，便于以后接 Dio）。
@JsonSerializable()
class CounterPushRequestDto {
  const CounterPushRequestDto({required this.count});

  factory CounterPushRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CounterPushRequestDtoFromJson(json);

  final int count;

  Map<String, dynamic> toJson() => _$CounterPushRequestDtoToJson(this);
}
