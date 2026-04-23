class TaskValidators {
  const TaskValidators._();

  static const taskMaxLength = 500;
  static const commentMaxLength = 500;

  static String? validateTaskText(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 'Digite uma tarefa.';
    }

    if (text.length > taskMaxLength) {
      return 'A tarefa deve ter no máximo $taskMaxLength caracteres.';
    }

    return null;
  }

  static String? validateCommentText(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 'Digite um comentário.';
    }

    if (text.length > commentMaxLength) {
      return 'O comentário deve ter no máximo $commentMaxLength caracteres.';
    }

    return null;
  }

  static String? validateDueDate(DateTime? dueDate, DateTime now) {
    if (dueDate == null) {
      return null;
    }

    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (due.isBefore(today)) {
      return 'Escolha uma data de hoje em diante.';
    }

    return null;
  }
}
