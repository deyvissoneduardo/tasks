import '../models/due_status.dart';

class DueStatusResolver {
  const DueStatusResolver._();

  static DueStatus resolve({
    required DateTime now,
    required DateTime? dueDate,
    required bool isCompleted,
  }) {
    if (dueDate == null || isCompleted) {
      return DueStatus.none;
    }

    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final days = due.difference(today).inDays;

    return switch (days) {
      < 0 => DueStatus.overdue,
      15 => DueStatus.warning15,
      10 => DueStatus.warning10,
      5 => DueStatus.warning5,
      3 => DueStatus.warning3,
      2 => DueStatus.warning2,
      1 => DueStatus.warning1,
      _ => DueStatus.none,
    };
  }
}
