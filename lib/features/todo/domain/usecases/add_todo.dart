import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
final class AddTodo extends UseCase<String, TodoEntity> {
  AddTodo(this._repository);

  final TodoRepository _repository;

  @override
  Future<Result<TodoEntity>> execute(String title) async {
    return Result.data(await _repository.add(title));
  }
}
