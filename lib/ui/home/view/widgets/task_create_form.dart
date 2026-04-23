import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/validation/task_validators.dart';
import '../../view_model/home_view_model.dart';
import 'task_date_format.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({super.key});

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends State<TaskCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: const Color(0xFFFFF0F5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Criar com carinho',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 640;
                  final input = TextFormField(
                    controller: _controller,
                    maxLength: TaskValidators.taskMaxLength,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      hintText: 'Digite algo importante para vocês',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: (value) =>
                        viewModel.validateTaskText(value ?? ''),
                  );
                  final controls = _CreateControls(
                    dueDate: _dueDate,
                    isSaving: viewModel.isSaving,
                    onPickDate: _pickDate,
                    onClearDate: _dueDate == null
                        ? null
                        : () => setState(() => _dueDate = null),
                    onSave: _save,
                  );

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [input, const SizedBox(height: 12), controls],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: input),
                      const SizedBox(width: 12),
                      SizedBox(width: 250, child: controls),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final saved = await context.read<HomeViewModel>().createTask(
      _controller.text,
      _dueDate,
    );

    if (!mounted || !saved) {
      return;
    }

    _controller.clear();
    setState(() => _dueDate = null);
  }
}

class _CreateControls extends StatelessWidget {
  const _CreateControls({
    required this.dueDate,
    required this.isSaving,
    required this.onPickDate,
    required this.onSave,
    this.onClearDate,
  });

  final DateTime? dueDate;
  final bool isSaving;
  final VoidCallback onPickDate;
  final VoidCallback? onClearDate;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final dueDate = this.dueDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: isSaving ? null : onPickDate,
          icon: const Icon(Icons.event_available_outlined),
          label: Text(
            dueDate == null ? 'Definir prazo' : formatTaskDate(dueDate),
          ),
        ),
        if (dueDate != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: isSaving ? null : onClearDate,
            icon: const Icon(Icons.close),
            label: const Text('Remover prazo'),
          ),
        ],
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: isSaving ? null : onSave,
          icon: isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.favorite_border),
          label: const Text('Salvar'),
        ),
      ],
    );
  }
}
