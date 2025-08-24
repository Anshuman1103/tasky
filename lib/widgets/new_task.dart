import 'package:flutter/material.dart';
import 'package:tasky/services/task_services.dart';
import 'package:uuid/uuid.dart';
import 'package:tasky/models/task.dart';

class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({
    super.key,
    this.taskToEdit,
  });

  // This parameter is now optional and holds the task to edit
  final Task? taskToEdit;

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
  void initState() {
    super.initState();
    // Check if a task was passed in for editing
    if (widget.taskToEdit != null) {
      // Pre-populate the fields with the existing task's data
      _titleController.text = widget.taskToEdit!.title;
      _detailController.text = widget.taskToEdit!.detail ?? '';
      _selectedPriority = widget.taskToEdit!.priority;
    }
  }

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
      // Check if we are editing an existing task or creating a new one
      if (widget.taskToEdit != null) {
        // Update existing task
        final updatedTask = Task(
          id: widget.taskToEdit!.id,
          title: _titleController.text.trim(),
          detail: _detailController.text.trim().isEmpty
              ? null
              : _detailController.text.trim(),
          priority: _selectedPriority,
          isCompleted: widget.taskToEdit!.isCompleted,
          time: widget.taskToEdit!.time,
        );
        try {
          await _taskService.updateTask(updatedTask);
          if (mounted) Navigator.of(context).pop();
        } catch (e) {
          print('Error updating task: $e');
        }
      } else {
        // Create a new task
        const uuid = Uuid();
        final String taskId = uuid.v4();
        final newTask = Task(
          id: taskId,
          title: _titleController.text.trim(),
          detail: _detailController.text.trim().isEmpty
              ? null
              : _detailController.text.trim(),
          priority: _selectedPriority,
          isCompleted: false,
        );
        try {
          await _taskService.addTask(newTask);
          if (mounted) Navigator.of(context).pop();
        } catch (e) {
          print('Error adding task: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
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
              Text(
                widget.taskToEdit != null ? "Edit Task" : "Add Task",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Task Title",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7)),
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
              TextFormField(
                controller: _detailController,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Task Details (optional)",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Priority",
                  hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7)),
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
                        widget.taskToEdit != null ? "Update Task" : "Add Task",
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
