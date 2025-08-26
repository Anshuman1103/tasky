import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/models/task.dart';
import 'package:tasky/services/task_services.dart';
import 'package:tasky/widgets/task_tile.dart';
import 'package:tasky/widgets/new_task.dart';
import 'package:tasky/widgets/filter_sheet.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TaskService _taskService = TaskService();
  TaskFilter _currentFilter = TaskFilter.all;

  void _showNewTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const NewTaskSheet();
      },
    );
  }

  void _showEditTaskModal(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return NewTaskSheet(taskToEdit: task);
      },
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterSheet(
          onFilterSelected: (filter) {
            setState(() {
              _currentFilter = filter;
            });
          },
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getTaskCategory(DateTime taskTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final endOfWeek = today.add(const Duration(days: 7));
    final taskDay = DateTime(taskTime.year, taskTime.month, taskTime.day);

    if (taskDay.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (taskDay.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else if (taskDay.isAfter(today) && taskDay.isBefore(endOfWeek)) {
      return 'This Week';
    } else {
      return 'Older';
    }
  }

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
        groupedTasks['Older']!.add(task);
      }
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM');
    final todayDate = formatter.format(now);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      const Color.fromARGB(255, 128, 92, 212)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
              centerTitle: false,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todayDate,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    "My Tasks",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showSnackBar(
                    context, "Search feature is currently unavailable!"),
                icon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
              ),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
                tooltip: "Log out",
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasks(filter: _currentFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No tasks found. Add a new task to get started!',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final tasks = snapshot.data!;
                final groupedTasks = _groupTasks(tasks);

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedTasks.keys.map((day) {
                      if (groupedTasks[day]!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 8.0, top: 16.0),
                            child: Text(
                              day,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          ...groupedTasks[day]!.map((task) {
                            return TaskTile(
                              task: task,
                              onEdit: () => _showEditTaskModal(task),
                              onDelete: () async =>
                                  await _taskService.deleteTask(task.id),
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
                          }),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewTaskModal,
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _showFilterModal,
                icon: const Icon(Icons.filter_list),
                color: theme.colorScheme.onSecondary,
                tooltip: "Filter Tasks",
              ),
              const SizedBox(width: 48), // Spacer for the FAB
              IconButton(
                onPressed: () => _showSnackBar(
                    context, "User profile feature is currently unavailable!"),
                icon: const Icon(Icons.person),
                color: theme.colorScheme.onSecondary,
                tooltip: "User Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
