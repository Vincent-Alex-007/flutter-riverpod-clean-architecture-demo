import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_entity.freezed.dart';

/// 待办事项领域实体
@freezed
class TodoEntity with _$TodoEntity {
  const TodoEntity({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  @override
  final int id;
  @override
  final String title;
  @override
  final bool completed;
  @override
  final DateTime createdAt;
}
