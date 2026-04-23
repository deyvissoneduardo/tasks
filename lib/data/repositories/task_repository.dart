import '../../domain/models/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchTasks();

  Future<void> createTask(CreateTaskInput input);

  Future<void> updateTask(UpdateTaskInput input);

  Future<void> updateCompletion({
    required String taskId,
    required bool isCompleted,
  });

  Future<void> deleteTask(String taskId);

  Future<void> addComment(AddCommentInput input);

  Future<void> addReply(AddReplyInput input);
}

class CreateTaskInput {
  const CreateTaskInput({required this.text, this.dueDate});

  final String text;
  final DateTime? dueDate;
}

class UpdateTaskInput {
  const UpdateTaskInput({
    required this.taskId,
    required this.text,
    this.dueDate,
  });

  final String taskId;
  final String text;
  final DateTime? dueDate;
}

class AddCommentInput {
  const AddCommentInput({required this.taskId, required this.text});

  final String taskId;
  final String text;
}

class AddReplyInput {
  const AddReplyInput({
    required this.taskId,
    required this.commentId,
    required this.text,
  });

  final String taskId;
  final String commentId;
  final String text;
}
