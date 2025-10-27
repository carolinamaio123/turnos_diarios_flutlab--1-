import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_diarios/main.dart';

void main() {
  testWidgets('Smoke test mínimo', (WidgetTester tester) async {
    await tester.pumpWidget(const ScheduleApp());
    expect(find.byType(ScheduleApp), findsOneWidget);
  });
}
