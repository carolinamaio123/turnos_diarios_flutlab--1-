import 'package:flutter_test/flutter_test.dart';
import 'package:meu_app/main.dart'; // muda para o teu package/main.dart

void main() {
  testWidgets('Smoke test mínimo', (WidgetTester tester) async {
    // Carrega a app
    await tester.pumpWidget(const MyApp());

    // Apenas verifica que o widget inicial existe
    expect(find.byType(MyApp), findsOneWidget);
  });
}
