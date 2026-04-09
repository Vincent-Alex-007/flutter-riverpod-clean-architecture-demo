import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';

part 'todo_riverpod.g.dart';

/// 待办事项状态管理
@riverpod
class TodoRiverpod extends _$TodoRiverpod {
  @override
  FutureOr<List<TodoEntity>> build() async {
    final result = await getIt<GetTodos>().call();
    return result.value ?? [];
  }

  /// 添加待办事项
  Future<void> add(String title) async {
    await getIt<AddTodo>().call(title);
    ref.invalidateSelf();
  }

  /// 切换完成状态
  Future<void> toggleCompleted(int id) async {
    await getIt<ToggleTodo>().call(id);
    ref.invalidateSelf();
  }

  /// 删除待办事项
  Future<void> delete(int id) async {
    await getIt<DeleteTodo>().call(id);
    ref.invalidateSelf();
  }
}
