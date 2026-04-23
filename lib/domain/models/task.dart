import 'task_comment.dart';

class Task {
  const Task({
    required this.id,
    required this.text,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.comments = const [],
  });

  final String id;
  final String text;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final List<TaskComment> comments;

  Task copyWith({
    String? id,
    String? text,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    bool clearDueDate = false,
    List<TaskComment>? comments,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      comments: comments ?? this.comments,
    );
  }
}
