import 'package:flutter_test/flutter_test.dart';
import 'package:startupet/injection_container.dart' as di;
import 'package:startupet/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await di.initDependencies();
    await tester.pumpWidget(const StartupetApp(isAuthenticated: true));
    expect(find.text('StartupEt'), findsOneWidget);
  });
}
