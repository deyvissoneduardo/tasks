import 'task_reply.dart';

class TaskComment {
  const TaskComment({
    required this.id,
    required this.text,
    required this.createdAt,
    this.updatedAt,
    this.replies = const [],
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TaskReply> replies;
}
