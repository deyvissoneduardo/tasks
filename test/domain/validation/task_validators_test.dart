import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/domain/validation/task_validators.dart';

void main() {
  test('validates task text', () {
    expect(TaskValidators.validateTaskText('   '), 'Digite uma tarefa.');
    expect(TaskValidators.validateTaskText('Comprar pão'), isNull);
  });

  test('validates past due date', () {
    expect(
      TaskValidators.validateDueDate(
        DateTime(2026, 4, 22),
        DateTime(2026, 4, 23),
      ),
      'Escolha uma data de hoje em diante.',
    );
  });
}
