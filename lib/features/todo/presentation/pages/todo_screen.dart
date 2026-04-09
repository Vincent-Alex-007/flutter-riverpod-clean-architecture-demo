import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/todo_entity.dart';
import '../providers/todo_riverpod.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addTodo() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    _controller.clear();
    await ref.read(todoRiverpodProvider.notifier).add(title);
  }

  @override
  Widget build(BuildContext context) {
    final asyncTodos = ref.watch(todoRiverpodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Drift Demo · 待办事项')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '输入待办事项...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _addTodo,
                  child: const Text('添加'),
                ),
              ],
            ),
          ),
          Expanded(
            child: asyncTodos.when(
              data: (todos) => todos.isEmpty
                  ? const Center(child: Text('暂无待办事项'))
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) =>
                          _TodoTile(todo: todos[index]),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(todoRiverpodProvider.notifier);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => notifier.delete(todo.id),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) => notifier.toggleCompleted(todo.id),
        ),
        title: Text(
          todo.title,
          style: todo.completed
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          '${todo.createdAt.month}/${todo.createdAt.day} '
          '${todo.createdAt.hour}:${todo.createdAt.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
