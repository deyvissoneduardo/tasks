import 'package:flutter/material.dart';

import '../../../../domain/models/task_filter.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    required this.selectedFilter,
    required this.pendingCount,
    required this.completedCount,
    required this.onChanged,
    super.key,
  });

  final TaskFilter selectedFilter;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<TaskFilter>(
        segments: [
          ButtonSegment(
            value: TaskFilter.all,
            icon: const Icon(Icons.all_inbox_outlined),
            label: Text('Todas (${pendingCount + completedCount})'),
          ),
          ButtonSegment(
            value: TaskFilter.pending,
            icon: const Icon(Icons.radio_button_unchecked),
            label: Text('Pendentes ($pendingCount)'),
          ),
          ButtonSegment(
            value: TaskFilter.completed,
            icon: const Icon(Icons.check_circle_outline),
            label: Text('Concluídas ($completedCount)'),
          ),
        ],
        selected: {selectedFilter},
        onSelectionChanged: (selection) => onChanged(selection.single),
      ),
    );
  }
}
