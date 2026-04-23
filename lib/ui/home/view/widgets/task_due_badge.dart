import 'package:flutter/material.dart';

import '../../../../domain/models/due_status.dart';
import '../../../../domain/models/task.dart';
import '../../../../domain/services/due_status_resolver.dart';
import 'task_date_format.dart';

class TaskDueBadge extends StatelessWidget {
  const TaskDueBadge({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate;
    if (dueDate == null) {
      return const SizedBox.shrink();
    }

    final status = DueStatusResolver.resolve(
      now: DateTime.now(),
      dueDate: dueDate,
      isCompleted: task.isCompleted,
    );
    final theme = Theme.of(context);
    final colors = _colorsFor(theme.colorScheme, status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_iconFor(status), size: 16, color: colors.foreground),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _labelFor(status, dueDate),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _BadgeColors _colorsFor(ColorScheme colorScheme, DueStatus status) {
    return switch (status) {
      DueStatus.overdue => _BadgeColors(
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
      ),
      DueStatus.none => _BadgeColors(
        background: const Color(0xFFEAF7E9),
        foreground: colorScheme.onTertiaryContainer,
      ),
      _ => _BadgeColors(
        background: const Color(0xFFFFE7F0),
        foreground: colorScheme.onPrimaryContainer,
      ),
    };
  }

  IconData _iconFor(DueStatus status) {
    return switch (status) {
      DueStatus.overdue => Icons.warning_amber_rounded,
      DueStatus.none => Icons.event_available_outlined,
      _ => Icons.favorite_border,
    };
  }

  String _labelFor(DueStatus status, DateTime dueDate) {
    return switch (status) {
      DueStatus.overdue => 'Vencida em ${formatTaskDate(dueDate)}',
      DueStatus.warning15 => 'Faltam 15 dias',
      DueStatus.warning10 => 'Faltam 10 dias',
      DueStatus.warning5 => 'Faltam 5 dias',
      DueStatus.warning3 => 'Faltam 3 dias',
      DueStatus.warning2 => 'Faltam 2 dias',
      DueStatus.warning1 => 'Falta 1 dia',
      DueStatus.none => 'Prazo ${formatTaskDate(dueDate)}',
    };
  }
}

class _BadgeColors {
  const _BadgeColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
