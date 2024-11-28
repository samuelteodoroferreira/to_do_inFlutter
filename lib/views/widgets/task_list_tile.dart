import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Function(Task) onToggleCompletion;
  final Function(int) onDelete;

  const TaskListTile({super.key, 
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggleCompletion(task),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(task.id!),
      ),
    );
  }
}
