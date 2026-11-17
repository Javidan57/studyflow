
import 'package:flutter_test/flutter_test.dart';
import 'package:studyflow/utils/date_formatter.dart';

void main() {
  test('shortDate formats a date correctly', () {
    final date = DateTime(2026, 11, 17);

    expect(DateFormatter.shortDate(date), 'Tue, 17 Nov');
  });

  test('fullDate includes the year', () {
    final date = DateTime(2026, 11, 17);

    expect(DateFormatter.fullDate(date), 'Tue, 17 Nov 2026');
  });

  test('duration formats minutes correctly', () {
    expect(DateFormatter.duration(25), '25 min');
    expect(DateFormatter.duration(90), '1h 30m');
    expect(DateFormatter.duration(60), '1h');
  });

  test('clock formats seconds as MM:SS', () {
    expect(DateFormatter.clock(1500), '25:00');
    expect(DateFormatter.clock(65), '01:05');
  });

  test('dueLabel recognizes tomorrow', () {
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    expect(DateFormatter.dueLabel(tomorrow), 'Due tomorrow');
  });
}
