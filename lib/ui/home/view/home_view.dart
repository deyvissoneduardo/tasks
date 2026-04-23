import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/home_view_model.dart';
import 'widgets/task_create_form.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel? _viewModel;
  String? _pendingSnackBarMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final nextViewModel = context.read<HomeViewModel>();
    if (_viewModel == nextViewModel) {
      return;
    }

    _viewModel?.removeListener(_showActionMessage);
    _viewModel = nextViewModel..addListener(_showActionMessage);
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_showActionMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 20),
            SizedBox(width: 8),
            Text('Nossas Metas'),
          ],
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF7FA), Color(0xFFFFEDF3), Color(0xFFF2F6E9)],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: RefreshIndicator(
                onRefresh: viewModel.loadTasks,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.78,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.volunteer_activism_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Organizando a vida a dois',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TaskCreateForm(),
                    const SizedBox(height: 16),
                    TaskFilterBar(
                      selectedFilter: viewModel.selectedFilter,
                      pendingCount: viewModel.pendingCount,
                      completedCount: viewModel.completedCount,
                      onChanged: viewModel.setFilter,
                    ),
                    const SizedBox(height: 16),
                    _TaskListState(viewModel: viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showActionMessage() {
    final viewModel = _viewModel;
    final message = viewModel?.actionMessage;
    if (!mounted ||
        viewModel == null ||
        message == null ||
        _pendingSnackBarMessage == message) {
      return;
    }

    _pendingSnackBarMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      _pendingSnackBarMessage = null;
      viewModel.clearActionMessage();
    });
  }
}

class _TaskListState extends StatelessWidget {
  const _TaskListState({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final errorMessage = viewModel.errorMessage;
    if (errorMessage != null) {
      return _CenteredMessage(
        icon: Icons.cloud_off_outlined,
        title: errorMessage,
        action: FilledButton.icon(
          onPressed: viewModel.loadTasks,
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      );
    }

    final tasks = viewModel.visibleTasks;
    if (tasks.isEmpty) {
      return const _CenteredMessage(
        icon: Icons.favorite_border,
        title: 'Nenhuma tarefa por aqui.',
        subtitle: 'Crie uma tarefa para começar.',
      );
    }

    return Column(
      children: [
        for (final task in tasks) ...[
          TaskTile(task: task),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 44, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
