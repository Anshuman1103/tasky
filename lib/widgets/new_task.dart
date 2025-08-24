import 'package:flutter/material.dart';
import 'package:tasky/services/task_services.dart';
import 'package:uuid/uuid.dart';
import 'package:tasky/models/task.dart';

class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({super.key});

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends State<NewTaskSheet> {
  // A global key to hold the form state for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();

  // Instance of the TaskService to interact with Firestore
  final TaskService _taskService = TaskService();

  // State variable for the selected priority
  Priority _selectedPriority = Priority.low;

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  // Handles form validation and task submission
  Future<void> _submitForm() async {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      // Create a new unique ID for the task
      const uuid = Uuid();
      final String taskId = uuid.v4();

      // Create a new Task object
      final newTask = Task(
        id: taskId,
        title: _titleController.text.trim(),
        detail: _detailController.text.trim(),
        priority: _selectedPriority,
        isCompleted: false,
      );

      // Add the new task to Firestore
      try {
        await _taskService.addTask(newTask);
        // Close the modal sheet
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Handle potential errors, e.g., show a snackbar
        print('Error adding task: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add task.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      // Padding to prevent the content from being hidden by the keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Task Title",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Detail Field
              TextFormField(
                controller: _detailController,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Task Details (optional)",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 15),

              // Priority Dropdown Field
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Priority",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                dropdownColor: theme.colorScheme.secondary,
                style: TextStyle(color: theme.colorScheme.onSurface),
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(
                      priority.name.toUpperCase(),
                    ),
                  );
                }).toList(),
                onChanged: (Priority? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 25),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: _submitForm,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Add Task",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
