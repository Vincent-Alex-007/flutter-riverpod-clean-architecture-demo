import '../entities/todo_entity.dart';

/// 待办事项仓库接口
abstract interface class TodoRepository {
  /// 获取所有待办事项，按创建时间倒序
  Future<List<TodoEntity>> getAll();

  /// 添加待办事项，返回新建的实体
  Future<TodoEntity> add(String title);

  /// 切换完成状态
  Future<void> toggleCompleted(int id);

  /// 删除待办事项
  Future<void> delete(int id);
}
