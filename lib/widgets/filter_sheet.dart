import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Container(
        padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter Tasks',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            // List of filter options
            _buildFilterOption(
                context, 'All Tasks', TaskFilter.all, Icons.dashboard_outlined),
            _buildFilterOption(context, 'Completed', TaskFilter.completed,
                Icons.check_circle_outline),
            _buildFilterOption(context, 'Incomplete', TaskFilter.incomplete,
                Icons.circle_outlined),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildFilterOption(
                context, 'High Priority', TaskFilter.highPriority, Icons.flag,
                color: const Color.fromARGB(255, 255, 100, 100)),
            _buildFilterOption(context, 'Medium Priority',
                TaskFilter.mediumPriority, Icons.flag,
                color: const Color.fromARGB(255, 255, 195, 100)),
            _buildFilterOption(
                context, 'Low Priority', TaskFilter.lowPriority, Icons.flag,
                color: const Color.fromARGB(255, 100, 150, 255)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String title, TaskFilter filter, IconData icon,
      {Color? color}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          onTap: () {
            onFilterSelected(filter);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(icon, color: color ?? theme.colorScheme.onSurface),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
