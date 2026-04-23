import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/task.dart';
import '../../domain/models/task_comment.dart';
import '../../domain/models/task_reply.dart';

class TaskFirestoreMapper {
  const TaskFirestoreMapper._();

  static Task fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? const <String, dynamic>{};

    return Task(
      id: document.id,
      text: _readString(data['text']),
      isCompleted: data['isCompleted'] as bool? ?? false,
      createdAt: _readDate(data['createdAt']) ?? DateTime.now(),
      updatedAt: _readDate(data['updatedAt']),
      dueDate: _readDate(data['dueDate']),
      comments: _readComments(data['comments']),
    );
  }

  static List<TaskComment> _readComments(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (data) => TaskComment(
            id: _readString(data['id']),
            text: _readString(data['text']),
            createdAt: _readDate(data['createdAt']) ?? DateTime.now(),
            updatedAt: _readDate(data['updatedAt']),
            replies: _readReplies(data['replies']),
          ),
        )
        .where((comment) => comment.id.isNotEmpty && comment.text.isNotEmpty)
        .toList(growable: false);
  }

  static List<TaskReply> _readReplies(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (data) => TaskReply(
            id: _readString(data['id']),
            text: _readString(data['text']),
            createdAt: _readDate(data['createdAt']) ?? DateTime.now(),
            updatedAt: _readDate(data['updatedAt']),
          ),
        )
        .where((reply) => reply.id.isNotEmpty && reply.text.isNotEmpty)
        .toList(growable: false);
  }

  static String _readString(Object? value) {
    return value is String ? value : '';
  }

  static DateTime? _readDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
