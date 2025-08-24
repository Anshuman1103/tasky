import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky/models/task.dart';
import 'package:tasky/services/task_services.dart';
import 'package:tasky/widgets/new_task.dart';
import 'package:tasky/widgets/task_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TaskService _taskService = TaskService();

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const NewTaskSheet();
      },
    );
  }

  // Helper function to categorize tasks by date
  String _getTaskCategory(DateTime taskTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final taskDay = DateTime(taskTime.year, taskTime.month, taskTime.day);

    if (taskDay.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (taskDay.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (taskDay.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else if (taskDay.isAfter(today) &&
        taskDay.isBefore(today.add(const Duration(days: 7)))) {
      return 'This Week';
    } else {
      return 'Older';
    }
  }

  // Helper function to group tasks by category
  Map<String, List<Task>> _groupTasks(List<Task> tasks) {
    final Map<String, List<Task>> groupedTasks = {
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Older': [],
    };

    for (var task in tasks) {
      final category = _getTaskCategory(task.time);
      if (groupedTasks.containsKey(category)) {
        groupedTasks[category]!.add(task);
      } else {
        // Handle other future dates if needed
        groupedTasks['Older']!.add(task);
      }
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Tasks",
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            label: Text(
              "Log out",
              style: theme.textTheme.titleSmall!
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
            icon: Icon(
              Icons.exit_to_app,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _taskService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          // Group tasks
          final tasks = snapshot.data!;
          final groupedTasks = _groupTasks(tasks);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedTasks.keys.map((day) {
                if (groupedTasks[day]!.isEmpty) {
                  return const SizedBox.shrink(); // Hide empty sections
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        day,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedTasks[day]!.length,
                      itemBuilder: (context, index) {
                        final task = groupedTasks[day]![index];
                        return TaskTile(
                          task: task,
                          onEdit: () {
                            // TODO: Implement edit logic
                            print('Edit task: ${task.title}');
                          },
                          onDelete: () async {
                            await _taskService.deleteTask(task.id);
                          },
                          onToggleComplete: () async {
                            final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              detail: task.detail,
                              priority: task.priority,
                              isCompleted: !task.isCompleted,
                              time: task.time,
                            );
                            await _taskService.updateTask(updatedTask);
                          },
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
