import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  /// The task object to display. This must be a Task object imported
  /// from your project's model file.
  final Task task;

  /// A callback function to be executed when the edit button is pressed.
  final VoidCallback onEdit;

  /// A callback function to be executed when the delete button is pressed.
  final VoidCallback onDelete;

  /// A callback function to be executed when the task is tapped,
  /// typically to toggle its completion status.
  final VoidCallback onToggleComplete;

  /// A helper function to get the color associated with a task's priority.
  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color.fromARGB(255, 255, 100, 100);
      case Priority.medium:
        return const Color.fromARGB(255, 255, 195, 100);
      case Priority.low:
        return const Color.fromARGB(255, 100, 150, 255);
      default:
        return const Color.fromARGB(255, 219, 219, 219);
    }
  }

  /// A function to show a confirmation dialog before deleting a task.
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Confirm Deletion",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this task?",
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog without deleting the task.
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // First, close the dialog.
                Navigator.of(context).pop();
                // Then, execute the onDelete callback to delete the task.
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        elevation: 2,
        shadowColor: const Color.fromARGB(255, 230, 230, 230),
        child: InkWell(
          onTap: onToggleComplete,
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: [
                // Completion checkbox/circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? theme.colorScheme.primary
                          : const Color.fromARGB(255, 150, 150, 150),
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
                const SizedBox(width: 16),
                // Task title and detail
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurface.withOpacity(0.5)
                              : theme.colorScheme.onSurface,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (task.detail != null && task.detail!.isNotEmpty)
                        Text(
                          task.detail!,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Priority tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: getPriorityColor(task.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: getPriorityColor(task.priority),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Edit button
                IconButton(
                  icon: Icon(Icons.mode_edit_outline,
                      color: theme.colorScheme.onSecondary),
                  onPressed: onEdit,
                  tooltip: 'Edit Task',
                ),
                // Delete button with confirmation dialog
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  tooltip: 'Delete Task',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
