import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// 待办事项表
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// 应用本地数据库
///
/// 使用 drift 作为 SQLite ORM。
/// 在此文件中定义表（继承 Table 的类），然后运行 build_runner 生成代码。
/// Feature 层的 data source 通过 DI 获取此实例进行数据库操作。
@DriftDatabase(tables: [TodoItems])
final class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 在此处理版本迁移
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
