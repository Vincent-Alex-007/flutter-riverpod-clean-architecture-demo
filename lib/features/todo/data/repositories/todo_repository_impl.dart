import 'package:injectable/injectable.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';

@LazySingleton(as: TodoRepository)
final class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._local);

  final TodoLocalDataSource _local;

  @override
  Future<List<TodoEntity>> getAll() => _local.getAll();

  @override
  Future<TodoEntity> add(String title) => _local.insert(title);

  @override
  Future<void> toggleCompleted(int id) => _local.toggleCompleted(id);

  @override
  Future<void> delete(int id) => _local.delete(id);
}
