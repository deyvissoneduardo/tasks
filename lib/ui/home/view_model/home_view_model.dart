import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/logging/app_logger.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../domain/models/task.dart';
import '../../../domain/models/task_filter.dart';
import '../../../domain/validation/task_validators.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._taskRepository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final TaskRepository _taskRepository;
  final DateTime Function() _now;
  StreamSubscription<List<Task>>? _tasksSubscription;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _actionMessage;
  TaskFilter _selectedFilter = TaskFilter.all;
  List<Task> _tasks = const [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get actionMessage => _actionMessage;
  TaskFilter get selectedFilter => _selectedFilter;
  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get visibleTasks {
    return switch (_selectedFilter) {
      TaskFilter.all => List.unmodifiable(_tasks),
      TaskFilter.pending => List.unmodifiable(
        _tasks.where((task) => !task.isCompleted),
      ),
      TaskFilter.completed => List.unmodifiable(
        _tasks.where((task) => task.isCompleted),
      ),
    };
  }

  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;
  int get completedCount => _tasks.where((task) => task.isCompleted).length;

  void start() {
    if (_tasksSubscription != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _tasksSubscription = _taskRepository.watchTasks().listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _isLoading = false;
        _errorMessage = _messageFromError(
          error,
          fallback: 'Não foi possível carregar as tarefas.',
        );
        AppLogger.error(_errorMessage!, error: error, stackTrace: stackTrace);
        notifyListeners();
      },
    );
  }

  Future<void> loadTasks() async {
    await _tasksSubscription?.cancel();
    _tasksSubscription = null;
    start();
  }

  void setFilter(TaskFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }

    _selectedFilter = filter;
    notifyListeners();
  }

  String? validateTaskText(String value) {
    return TaskValidators.validateTaskText(value);
  }

  String? validateCommentText(String value) {
    return TaskValidators.validateCommentText(value);
  }

  String? validateDueDate(DateTime? dueDate) {
    return TaskValidators.validateDueDate(dueDate, _now());
  }

  Future<bool> createTask(String text, DateTime? dueDate) async {
    final trimmedText = text.trim();
    final validationMessage =
        validateTaskText(trimmedText) ?? validateDueDate(dueDate);
    if (validationMessage != null) {
      _actionMessage = validationMessage;
      notifyListeners();
      return false;
    }

    return _runAction(
      failureMessage: 'Não foi possível salvar a tarefa.',
      action: () => _taskRepository.createTask(
        CreateTaskInput(text: trimmedText, dueDate: dueDate),
      ),
    );
  }

  Future<bool> updateTask({
    required String taskId,
    required String text,
    required DateTime? dueDate,
  }) async {
    final trimmedText = text.trim();
    final validationMessage =
        validateTaskText(trimmedText) ?? validateDueDate(dueDate);
    if (validationMessage != null) {
      _actionMessage = validationMessage;
      notifyListeners();
      return false;
    }

    return _runAction(
      failureMessage: 'Não foi possível atualizar a tarefa.',
      action: () => _taskRepository.updateTask(
        UpdateTaskInput(taskId: taskId, text: trimmedText, dueDate: dueDate),
      ),
    );
  }

  Future<bool> toggleTask(Task task) async {
    return _runAction(
      failureMessage: 'Não foi possível atualizar o status.',
      action: () => _taskRepository.updateCompletion(
        taskId: task.id,
        isCompleted: !task.isCompleted,
      ),
    );
  }

  Future<bool> deleteTask(String taskId) async {
    return _runAction(
      failureMessage: 'Não foi possível excluir a tarefa.',
      action: () => _taskRepository.deleteTask(taskId),
    );
  }

  Future<bool> addComment({
    required String taskId,
    required String text,
  }) async {
    final trimmedText = text.trim();
    final validationMessage = validateCommentText(trimmedText);
    if (validationMessage != null) {
      _actionMessage = validationMessage;
      notifyListeners();
      return false;
    }

    return _runAction(
      failureMessage: 'Não foi possível salvar o comentário.',
      action: () => _taskRepository.addComment(
        AddCommentInput(taskId: taskId, text: trimmedText),
      ),
    );
  }

  Future<bool> addReply({
    required String taskId,
    required String commentId,
    required String text,
  }) async {
    final trimmedText = text.trim();
    final validationMessage = validateCommentText(trimmedText);
    if (validationMessage != null) {
      _actionMessage = validationMessage;
      notifyListeners();
      return false;
    }

    return _runAction(
      failureMessage: 'Não foi possível salvar a resposta.',
      action: () => _taskRepository.addReply(
        AddReplyInput(taskId: taskId, commentId: commentId, text: trimmedText),
      ),
    );
  }

  void clearActionMessage() {
    if (_actionMessage == null) {
      return;
    }

    _actionMessage = null;
    notifyListeners();
  }

  Future<bool> _runAction({
    required String failureMessage,
    required Future<void> Function() action,
  }) async {
    _isSaving = true;
    _actionMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on AppException catch (error, stackTrace) {
      _actionMessage = error.message;
      AppLogger.error(
        error.message,
        error: error.cause,
        stackTrace: stackTrace,
      );
    } on Object catch (error, stackTrace) {
      _actionMessage = failureMessage;
      AppLogger.error(failureMessage, error: error, stackTrace: stackTrace);
    } finally {
      _isSaving = false;
      notifyListeners();
    }

    return false;
  }

  String _messageFromError(Object error, {required String fallback}) {
    if (error is AppException) {
      return error.message;
    }

    return fallback;
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
