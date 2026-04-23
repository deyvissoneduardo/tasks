import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/task.dart';
import '../../view_model/home_view_model.dart';
import 'task_comments_section.dart';
import 'task_date_format.dart';
import 'task_due_badge.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({required this.task, super.key});

  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final _editController = TextEditingController();
  DateTime? _editDueDate;
  bool _isEditing = false;
  bool _showComments = false;

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: task.isCompleted
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.primary,
              width: 5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) =>
                        context.read<HomeViewModel>().toggleTask(task),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _isEditing
                        ? _EditTaskForm(
                            controller: _editController,
                            dueDate: _editDueDate,
                            onPickDate: _pickEditDate,
                            onClearDate: () => setState(() {
                              _editDueDate = null;
                            }),
                            onCancel: () => setState(() {
                              _isEditing = false;
                            }),
                            onSave: _saveEdit,
                          )
                        : _TaskSummary(task: task),
                  ),
                  if (!_isEditing)
                    Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          onPressed: _startEdit,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Excluir',
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                ],
              ),
              if (!_isEditing) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TaskDueBadge(task: task),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _showComments = !_showComments;
                      }),
                      icon: Icon(
                        _showComments
                            ? Icons.expand_less
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        task.comments.isEmpty
                            ? 'Comentários'
                            : 'Comentários (${task.comments.length})',
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TaskCommentsSection(task: task),
                  ),
                  crossFadeState: _showComments
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 180),
                ),
                if (task.isCompleted) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 15,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Concluída',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _startEdit() {
    _editController.text = widget.task.text;
    _editDueDate = widget.task.dueDate;
    setState(() => _isEditing = true);
  }

  Future<void> _pickEditDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _editDueDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _editDueDate = picked);
    }
  }

  Future<void> _saveEdit() async {
    final saved = await context.read<HomeViewModel>().updateTask(
      taskId: widget.task.id,
      text: _editController.text,
      dueDate: _editDueDate,
    );

    if (mounted && saved) {
      setState(() => _isEditing = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir tarefa?'),
          content: const Text(
            'A tarefa e seus comentários serão removidos definitivamente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await context.read<HomeViewModel>().deleteTask(widget.task.id);
  }
}

class _TaskSummary extends StatelessWidget {
  const _TaskSummary({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        task.text,
        style: theme.textTheme.titleMedium?.copyWith(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _EditTaskForm extends StatelessWidget {
  const _EditTaskForm({
    required this.controller,
    required this.dueDate,
    required this.onPickDate,
    required this.onClearDate,
    required this.onCancel,
    required this.onSave,
  });

  final TextEditingController controller;
  final DateTime? dueDate;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          maxLength: 500,
          minLines: 1,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Editar tarefa',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: onPickDate,
              icon: const Icon(Icons.event_available_outlined),
              label: Text(
                dueDate == null ? 'Definir prazo' : formatTaskDate(dueDate!),
              ),
            ),
            if (dueDate != null)
              TextButton.icon(
                onPressed: onClearDate,
                icon: const Icon(Icons.close),
                label: const Text('Remover prazo'),
              ),
            TextButton(onPressed: onCancel, child: const Text('Cancelar')),
            FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
            ),
          ],
        ),
      ],
    );
  }
}
