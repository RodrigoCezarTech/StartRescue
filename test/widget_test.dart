
import 'package:flutter_test/flutter_test.dart';
import 'package:start_rescue/main.dart';

void main() {
  testWidgets('StartRescue inicia sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const StartRescueApp());

    expect(find.byType(StartRescueApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
