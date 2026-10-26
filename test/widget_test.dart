import 'package:flutter_test/flutter_test.dart';
import 'package:brickup/main.dart';

void main() {
  testWidgets('Brickup app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrickupApp());
    expect(find.text('Brickup'), findsOneWidget);
  });
}
