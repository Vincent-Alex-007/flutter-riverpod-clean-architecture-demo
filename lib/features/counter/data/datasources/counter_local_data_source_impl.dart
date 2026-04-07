import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'counter_local_data_source.dart';

@LazySingleton(as: CounterLocalDataSource)
final class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  CounterLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'feature.counter_demo.value';

  @override
  Future<int?> readCounter() async => _prefs.getInt(_key);

  @override
  Future<void> writeCounter(int value) async {
    await _prefs.setInt(_key, value);
  }
}
