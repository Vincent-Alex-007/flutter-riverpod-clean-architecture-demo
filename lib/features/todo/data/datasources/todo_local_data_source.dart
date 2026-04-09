import '../../domain/entities/todo_entity.dart';

/// 待办事项本地数据源接口
abstract interface class TodoLocalDataSource {
  Future<List<TodoEntity>> getAll();

  Future<TodoEntity> insert(String title);

  Future<void> toggleCompleted(int id);

  Future<void> delete(int id);
}
