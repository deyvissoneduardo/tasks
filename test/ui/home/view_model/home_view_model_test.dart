import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/core/errors/app_exception.dart';
import 'package:tasks/data/repositories/task_repository.dart';
import 'package:tasks/domain/models/task.dart';
import 'package:tasks/domain/models/task_filter.dart';
import 'package:tasks/ui/home/view_model/home_view_model.dart';

void main() {
  test('start stores tasks from the repository stream', () async {
    final repository = _FakeTaskRepository();
    final viewModel = HomeViewModel(repository);

    viewModel.start();
    repository.emit([
      Task(
        id: '1',
        text: 'Planejar a semana',
        isCompleted: false,
        createdAt: DateTime(2026),
      ),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.tasks.single.text, 'Planejar a semana');

    viewModel.dispose();
    repository.dispose();
  });

  test('start exposes app exception messages from stream errors', () async {
    final repository = _FakeTaskRepository();
    final viewModel = HomeViewModel(repository);

    viewModel.start();
    repository.emitError(const AppException('Não foi possível carregar.'));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, 'Não foi possível carregar.');
    expect(viewModel.tasks, isEmpty);

    viewModel.dispose();
    repository.dispose();
  });

  test('setFilter changes visible tasks without mutating data', () async {
    final repository = _FakeTaskRepository();
    final viewModel = HomeViewModel(repository);

    viewModel.start();
    repository.emit([
      Task(
        id: '1',
        text: 'Pendente',
        isCompleted: false,
        createdAt: DateTime(2026),
      ),
      Task(
        id: '2',
        text: 'Concluída',
        isCompleted: true,
        createdAt: DateTime(2026),
      ),
    ]);
    await Future<void>.delayed(Duration.zero);

    viewModel.setFilter(TaskFilter.pending);

    expect(viewModel.tasks.length, 2);
    expect(viewModel.visibleTasks.single.text, 'Pendente');

    viewModel.dispose();
    repository.dispose();
  });

  test('createTask validates empty text before calling repository', () async {
    final repository = _FakeTaskRepository();
    final viewModel = HomeViewModel(repository);

    final saved = await viewModel.createTask('   ', null);

    expect(saved, isFalse);
    expect(repository.createdTasks, isEmpty);
    expect(viewModel.actionMessage, 'Digite uma tarefa.');

    viewModel.dispose();
    repository.dispose();
  });
}

class _FakeTaskRepository implements TaskRepository {
  final _controller = StreamController<List<Task>>();
  final List<CreateTaskInput> createdTasks = [];

  @override
  Future<void> addComment(AddCommentInput input) async {}

  @override
  Future<void> addReply(AddReplyInput input) async {}

  @override
  Future<void> createTask(CreateTaskInput input) async {
    createdTasks.add(input);
  }

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

  void emit(List<Task> tasks) {
    _controller.add(tasks);
  }

  void emitError(Object error) {
    _controller.addError(error);
  }

  void dispose() {
    _controller.close();
  }
}
