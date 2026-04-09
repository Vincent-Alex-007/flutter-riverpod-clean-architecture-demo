import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ─── 表定义 ───

/// 待办事项表
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// 商品表
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();

  /// 价格（分），避免浮点精度问题
  IntColumn get priceInCents => integer()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// 购物车表
class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}

/// 订单表
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subtotalInCents => integer()();
  IntColumn get discountInCents => integer()();
  IntColumn get taxInCents => integer()();
  IntColumn get totalInCents => integer()();

  /// pending / completed / cancelled
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── 数据库 ───

/// 应用本地数据库
///
/// 使用 drift 作为 SQLite ORM。
/// 在此文件中定义表（继承 Table 的类），然后运行 build_runner 生成代码。
/// Feature 层的 data source 通过 DI 获取此实例进行数据库操作。
@LazySingleton()
@DriftDatabase(tables: [TodoItems, Products, CartItems, Orders])
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
        await _seedProducts();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 在此处理版本迁移
      },
    );
  }

  @disposeMethod
  Future<void> closeDatabase() => close();

  /// 初始化种子商品数据
  Future<void> _seedProducts() async {
    await batch((batch) {
      batch.insertAll(products, [
        ProductsCompanion.insert(
          name: 'Flutter 实战',
          description: const Value('Flutter 开发从入门到精通'),
          priceInCents: 6800,
          stock: const Value(50),
        ),
        ProductsCompanion.insert(
          name: 'Dart 编程语言',
          description: const Value('深入理解 Dart 语言核心特性'),
          priceInCents: 4500,
          stock: const Value(30),
        ),
        ProductsCompanion.insert(
          name: 'Clean Architecture',
          description: const Value('Robert C. Martin 经典架构设计'),
          priceInCents: 8900,
          stock: const Value(20),
        ),
        ProductsCompanion.insert(
          name: '设计模式',
          description: const Value('GoF 经典设计模式详解'),
          priceInCents: 5200,
          stock: const Value(40),
        ),
        ProductsCompanion.insert(
          name: '重构',
          description: const Value('改善既有代码的设计（第 2 版）'),
          priceInCents: 7600,
          stock: const Value(15),
        ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
