import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/models/task.dart';
import '../mappers/task_firestore_mapper.dart';
import '../repositories/task_repository.dart';

class TaskFirestoreService {
  TaskFirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('tasks');

  Future<void> addComment(AddCommentInput input) async {
    try {
      final comment = {
        'id': _tasks.doc().id,
        'text': input.text,
        'createdAt': Timestamp.now(),
        'updatedAt': null,
        'replies': <Map<String, dynamic>>[],
      };

      await _tasks.doc(input.taskId).update({
        'comments': FieldValue.arrayUnion([comment]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on Object catch (error) {
      throw AppException('Não foi possível salvar o comentário.', cause: error);
    }
  }

  Future<void> addReply(AddReplyInput input) async {
    try {
      final taskRef = _tasks.doc(input.taskId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(taskRef);
        final data = snapshot.data() ?? const <String, dynamic>{};
        final comments = _readMutableComments(data['comments']);
        final commentIndex = comments.indexWhere(
          (comment) => comment['id'] == input.commentId,
        );

        if (commentIndex == -1) {
          throw const AppException('O comentário não foi encontrado.');
        }

        final comment = Map<String, dynamic>.from(comments[commentIndex]);
        final replies = _readMutableReplies(comment['replies']);
        replies.add({
          'id': _tasks.doc().id,
          'text': input.text,
          'createdAt': Timestamp.now(),
          'updatedAt': null,
        });
        comment['replies'] = replies;
        comments[commentIndex] = comment;

        transaction.update(taskRef, {
          'comments': comments,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on AppException {
      rethrow;
    } on Object catch (error) {
      throw AppException('Não foi possível salvar a resposta.', cause: error);
    }
  }

  Future<void> createTask(CreateTaskInput input) async {
    try {
      await _tasks.add({
        'text': input.text,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'dueDate': input.dueDate == null
            ? null
            : Timestamp.fromDate(input.dueDate!),
        'comments': <Map<String, dynamic>>[],
      });
    } on Object catch (error) {
      throw AppException('Não foi possível salvar a tarefa.', cause: error);
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _tasks.doc(taskId).delete();
    } on Object catch (error) {
      throw AppException('Não foi possível excluir a tarefa.', cause: error);
    }
  }

  Future<void> updateCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      await _tasks.doc(taskId).update({
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on Object catch (error) {
      throw AppException('Não foi possível atualizar o status.', cause: error);
    }
  }

  Future<void> updateTask(UpdateTaskInput input) async {
    try {
      await _tasks.doc(input.taskId).update({
        'text': input.text,
        'dueDate': input.dueDate == null
            ? null
            : Timestamp.fromDate(input.dueDate!),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on Object catch (error) {
      throw AppException('Não foi possível atualizar a tarefa.', cause: error);
    }
  }

  Stream<List<Task>> watchTasks() {
    try {
      return _tasks
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(TaskFirestoreMapper.fromDocument)
                .toList(growable: false),
          );
    } on Object catch (error) {
      throw AppException('Não foi possível carregar as tarefas.', cause: error);
    }
  }

  List<Map<String, dynamic>> _readMutableComments(Object? value) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(Map<String, dynamic>.from)
        .toList();
  }

  List<Map<String, dynamic>> _readMutableReplies(Object? value) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(Map<String, dynamic>.from)
        .toList();
  }
}
