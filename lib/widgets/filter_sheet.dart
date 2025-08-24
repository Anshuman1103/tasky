import 'package:flutter/material.dart';

// Enum to represent the different filter options
enum TaskFilter {
  all,
  completed,
  incomplete,
  highPriority,
  mediumPriority,
  lowPriority,
}

// A widget to display the filter options in a modal sheet
class FilterSheet extends StatelessWidget {
  const FilterSheet({
    super.key,
    required this.onFilterSelected,
  });

  // Callback function to return the selected filter
  final Function(TaskFilter) onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Tasks',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // List of filter options
          _buildFilterOption(context, 'All Tasks', TaskFilter.all, Icons.list),
          _buildFilterOption(context, 'Completed', TaskFilter.completed,
              Icons.check_circle_outline),
          _buildFilterOption(context, 'Incomplete', TaskFilter.incomplete,
              Icons.circle_outlined),
          const Divider(),
          _buildFilterOption(
              context, 'High Priority', TaskFilter.highPriority, Icons.flag,
              color: Colors.red),
          _buildFilterOption(
              context, 'Medium Priority', TaskFilter.mediumPriority, Icons.flag,
              color: Colors.amber),
          _buildFilterOption(
              context, 'Low Priority', TaskFilter.lowPriority, Icons.flag,
              color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String title, TaskFilter filter, IconData icon,
      {Color? color}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: color ?? theme.colorScheme.onSurface),
      title: Text(title, style: theme.textTheme.bodyLarge),
      onTap: () {
        onFilterSelected(filter);
        Navigator.of(context)
            .pop(); // Close the modal sheet after selecting a filter
      },
    );
  }
}
