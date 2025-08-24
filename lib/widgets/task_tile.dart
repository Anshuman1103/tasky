import 'package:flutter/material.dart';
import 'package:tasky/models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.amber;
      case Priority.low:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        color: theme
            .colorScheme.surface, // Using surface color for card background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
        child: ListTile(
          onTap:
              onToggleComplete, // Tapping the tile can mark it as complete/incomplete
          // Leading widget to show task status and priority
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checkbox-like button to mark as completed
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    width: 2,
                  ),
                  color: task.isCompleted
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
                child: task.isCompleted
                    ? Icon(Icons.check,
                        size: 16, color: theme.colorScheme.onPrimary)
                    : null,
              ),
              const SizedBox(height: 4),
              // Small indicator for priority
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getPriorityColor(task.priority),
                ),
              ),
            ],
          ),
          // Task title
          title: Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: task.isCompleted
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          // Task detail (optional)
          subtitle: task.detail != null
              ? Text(
                  task.detail!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : null,
          // Trailing buttons for edit and delete
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: theme.colorScheme.onSurface),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
