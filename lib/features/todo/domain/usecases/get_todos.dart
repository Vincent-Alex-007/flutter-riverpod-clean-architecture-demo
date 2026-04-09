import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
final class GetTodos extends NoParamsUseCase<List<TodoEntity>> {
  GetTodos(this._repository);

  final TodoRepository _repository;

  @override
  Future<Result<List<TodoEntity>>> execute() async {
    return Result.data(await _repository.getAll());
  }
}
