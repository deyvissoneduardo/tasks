import 'dart:async';

import '../../domain/models/task.dart';
import '../../domain/models/task_comment.dart';
import '../../domain/models/task_reply.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository();

  final _controller = StreamController<List<Task>>.broadcast();
  final List<Task> _tasks = [];
  int _nextId = 1;

  @override
  Future<void> addComment(AddCommentInput input) async {
    _replaceTask(
      input.taskId,
      (task) => task.copyWith(
        comments: [
          ...task.comments,
          TaskComment(
            id: _generateId(),
            text: input.text,
            createdAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> addReply(AddReplyInput input) async {
    _replaceTask(
      input.taskId,
      (task) => task.copyWith(
        comments: task.comments
            .map((comment) {
              if (comment.id != input.commentId) {
                return comment;
              }

              return TaskComment(
                id: comment.id,
                text: comment.text,
                createdAt: comment.createdAt,
                updatedAt: comment.updatedAt,
                replies: [
                  ...comment.replies,
                  TaskReply(
                    id: _generateId(),
                    text: input.text,
                    createdAt: DateTime.now(),
                  ),
                ],
              );
            })
            .toList(growable: false),
      ),
    );
  }

  @override
  Future<void> createTask(CreateTaskInput input) async {
    _tasks.insert(
      0,
      Task(
        id: _generateId(),
        text: input.text,
        isCompleted: false,
        createdAt: DateTime.now(),
        dueDate: input.dueDate,
      ),
    );
    _emit();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    _emit();
  }

  @override
  Future<void> updateCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    _replaceTask(
      taskId,
      (task) =>
          task.copyWith(isCompleted: isCompleted, updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> updateTask(UpdateTaskInput input) async {
    _replaceTask(
      input.taskId,
      (task) => task.copyWith(
        text: input.text,
        dueDate: input.dueDate,
        clearDueDate: input.dueDate == null,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Stream<List<Task>> watchTasks() {
    Future<void>.microtask(_emit);
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  String _generateId() => '${_nextId++}';

  void _replaceTask(String taskId, Task Function(Task task) update) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    _tasks[index] = update(_tasks[index]);
    _emit();
  }

  void _emit() {
    _controller.add(List.unmodifiable(_tasks));
  }
}
