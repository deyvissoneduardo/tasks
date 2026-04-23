import '../../domain/models/task.dart';
import '../services/task_firestore_service.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._service);

  final TaskFirestoreService _service;

  @override
  Future<void> addComment(AddCommentInput input) {
    return _service.addComment(input);
  }

  @override
  Future<void> addReply(AddReplyInput input) {
    return _service.addReply(input);
  }

  @override
  Future<void> createTask(CreateTaskInput input) {
    return _service.createTask(input);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _service.deleteTask(taskId);
  }

  @override
  Future<void> updateCompletion({
    required String taskId,
    required bool isCompleted,
  }) {
    return _service.updateCompletion(taskId: taskId, isCompleted: isCompleted);
  }

  @override
  Future<void> updateTask(UpdateTaskInput input) {
    return _service.updateTask(input);
  }

  @override
  Stream<List<Task>> watchTasks() {
    // Repositories expose application-friendly data operations and hide service details from ViewModels.
    return _service.watchTasks();
  }
}
