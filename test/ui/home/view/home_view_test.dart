import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasks/data/repositories/task_repository.dart';
import 'package:tasks/domain/models/task.dart';
import 'package:tasks/ui/core/themes/app_theme.dart';
import 'package:tasks/ui/home/view/home_view.dart';
import 'package:tasks/ui/home/view_model/home_view_model.dart';

void main() {
  testWidgets('renders tasks loaded by the view model', (tester) async {
    final repository = _FakeTaskRepository([
      Task(
        id: '1',
        text: 'Criar estrutura do projeto',
        isCompleted: false,
        createdAt: DateTime(2026),
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository)..start(),
          child: const HomeView(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Nossas Metas'), findsOneWidget);
    expect(find.text('Criar estrutura do projeto'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

    repository.dispose();
  });
}

class _FakeTaskRepository implements TaskRepository {
  _FakeTaskRepository(List<Task> tasks) {
    Future<void>.microtask(() => _controller.add(tasks));
  }

  final _controller = StreamController<List<Task>>();

  @override
  Future<void> addComment(AddCommentInput input) async {}

  @override
  Future<void> addReply(AddReplyInput input) async {}

  @override
  Future<void> createTask(CreateTaskInput input) async {}

  @override
  Future<void> deleteTask(String taskId) async {}

  @override
  Future<void> updateCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {}

  @override
  Future<void> updateTask(UpdateTaskInput input) async {}

  @override
  Stream<List<Task>> watchTasks() => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
