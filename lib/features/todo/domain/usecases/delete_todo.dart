import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
final class DeleteTodo extends UseCase<int, void> {
  DeleteTodo(this._repository);

  final TodoRepository _repository;

  @override
  Future<Result<void>> execute(int id) async {
    await _repository.delete(id);
    return const Result.data(null);
  }
}
