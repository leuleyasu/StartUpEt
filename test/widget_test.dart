import 'package:flutter_test/flutter_test.dart';
import 'package:startupet/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const StartupetApp());
    expect(find.text('Startupet'), findsOneWidget);
  });
}
