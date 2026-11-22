
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyflow/widgets/priority_badge.dart';
import 'package:studyflow/theme/app_colors.dart';

void main() {
  testWidgets('PriorityBadge displays correct labels and colors',
          (WidgetTester tester) async {
        for (final priority in ['High', 'Medium', 'Low']) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PriorityBadge(priority: priority),
              ),
            ),
          );

          expect(find.text(priority), findsOneWidget);

          final expectedColor = PriorityBadge.colorFor(priority);
          final textWidget = tester.widget<Text>(find.text(priority));

          expect(textWidget.style?.color, expectedColor);
        }
      });

  test('PriorityBadge selects the correct colors', () {
    expect(PriorityBadge.colorFor('High'), AppColors.priorityHigh);
    expect(PriorityBadge.colorFor('Medium'), AppColors.priorityMedium);
    expect(PriorityBadge.colorFor('Low'), AppColors.priorityLow);
  });
}
