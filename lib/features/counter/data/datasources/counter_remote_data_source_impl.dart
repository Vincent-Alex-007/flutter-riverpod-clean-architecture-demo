import 'package:injectable/injectable.dart';

import '../../../../infrastructure/services/network/response_model.dart';
import '../dto/counter_remote_dto.dart';
import 'counter_remote_data_source.dart';

/// 模拟远程：先走「信封 + DTO」解析，再映射为 [int] 交给仓库。
///
/// 将 [simulateLoadFailure] 设为 `true` 可演示 load 走本地兜底。
@LazySingleton(as: CounterRemoteDataSource)
final class CounterRemoteDataSourceImpl implements CounterRemoteDataSource {
  CounterRemoteDataSourceImpl();

  /// 调试演示：为 true 时 [fetchCounter] 抛错，仓库回落到本地。
  static bool simulateLoadFailure = false;

  /// 模拟服务端当前值（与 JSON 中的 data.count 一致）。
  var _serverCounter = 0;

  @override
  Future<int> fetchCounter() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (simulateLoadFailure) {
      throw Exception('模拟远程拉取失败');
    }

    final envelope = <String, dynamic>{
      'code': 0,
      'msg': 'ok',
      'data': CounterCountDataDto(count: _serverCounter).toJson(),
    };

    final model = ResponseModel<CounterCountDataDto>.fromJson(
      envelope,
      (Object? json) =>
          CounterCountDataDto.fromJson(json! as Map<String, dynamic>),
    );

    if (!model.isSuccess) {
      throw Exception(model.msg.isEmpty ? 'remote business error' : model.msg);
    }

    final data = model.data;
    if (data == null) {
      throw Exception('remote data is null');
    }

    return data.count;
  }

  @override
  Future<void> pushCounter(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    // 模拟序列化请求体（真实项目里交给 Dio + Interceptor）
    final body = CounterPushRequestDto(count: value).toJson();
    final count = body['count'] as int?;
    if (count == null) {
      throw Exception('invalid push body');
    }
    _serverCounter = count;
  }
}
