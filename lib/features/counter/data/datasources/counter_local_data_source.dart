/// 本地端口：持久化计数，由基础设施实现（如 SharedPreferences）。
abstract interface class CounterLocalDataSource {
  Future<int?> readCounter();

  Future<void> writeCounter(int value);
}
