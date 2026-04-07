/// 远程端口：模拟 HTTP 拉取 / 推送，由基础设施提供具体实现。
abstract interface class CounterRemoteDataSource {
  /// 模拟 GET：延迟后返回「服务端」当前计数。
  Future<int> fetchCounter();

  /// 模拟 PUT/POST：将服务端计数更新为 [value]。
  Future<void> pushCounter(int value);
}
