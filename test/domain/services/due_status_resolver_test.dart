import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/domain/models/due_status.dart';
import 'package:tasks/domain/services/due_status_resolver.dart';

void main() {
  test('returns none when task is completed', () {
    final status = DueStatusResolver.resolve(
      now: DateTime(2026, 4, 23),
      dueDate: DateTime(2026, 4, 24),
      isCompleted: true,
    );

    expect(status, DueStatus.none);
  });

  test('returns expected warning milestones', () {
    final now = DateTime(2026, 4, 23);

    expect(
      DueStatusResolver.resolve(
        now: now,
        dueDate: DateTime(2026, 5, 8),
        isCompleted: false,
      ),
      DueStatus.warning15,
    );
    expect(
      DueStatusResolver.resolve(
        now: now,
        dueDate: DateTime(2026, 4, 24),
        isCompleted: false,
      ),
      DueStatus.warning1,
    );
  });

  test('returns overdue when due date has passed', () {
    final status = DueStatusResolver.resolve(
      now: DateTime(2026, 4, 23),
      dueDate: DateTime(2026, 4, 22),
      isCompleted: false,
    );

    expect(status, DueStatus.overdue);
  });
}
