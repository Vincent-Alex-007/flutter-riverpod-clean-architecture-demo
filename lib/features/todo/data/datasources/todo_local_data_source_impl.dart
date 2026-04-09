import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../infrastructure/services/database/app_database.dart';
import '../../domain/entities/todo_entity.dart';
import 'todo_local_data_source.dart';

/// 基于 drift 的待办事项本地数据源实现
@LazySingleton(as: TodoLocalDataSource)
final class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  TodoLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<TodoEntity>> getAll() async {
    final query = _db.select(_db.todoItems)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<TodoEntity> insert(String title) async {
    final id = await _db
        .into(_db.todoItems)
        .insert(TodoItemsCompanion.insert(title: title));
    final row = await (_db.select(
      _db.todoItems,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toEntity(row);
  }

  @override
  Future<void> toggleCompleted(int id) async {
    final row = await (_db.select(
      _db.todoItems,
    )..where((t) => t.id.equals(id))).getSingle();
    await (_db.update(_db.todoItems)..where((t) => t.id.equals(id))).write(
      TodoItemsCompanion(completed: Value(!row.completed)),
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.todoItems)..where((t) => t.id.equals(id))).go();
  }

  TodoEntity _toEntity(TodoItem row) {
    return TodoEntity(
      id: row.id,
      title: row.title,
      completed: row.completed,
      createdAt: row.createdAt,
    );
  }
}
