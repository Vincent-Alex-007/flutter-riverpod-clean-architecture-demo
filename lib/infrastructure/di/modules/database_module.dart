import 'package:injectable/injectable.dart';

import '../../services/database/app_database.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get database => AppDatabase();

  /// 销毁数据库连接，在 getIt.reset() 时自动调用
  @disposeMethod
  Future<void> closeDatabase(AppDatabase db) => db.close();
}
