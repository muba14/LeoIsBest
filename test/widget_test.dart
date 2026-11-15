import 'package:flutter_test/flutter_test.dart';
import 'package:leoisbest/main.dart';

void main() {
  testWidgets('App starts and shows the tabs', (tester) async {
    await tester.pumpWidget(const LeoIsBestApp());
    expect(find.text('VERSUS'), findsOneWidget);
    expect(find.text('WHY LEO'), findsOneWidget);
    expect(find.text('RECORDS'), findsOneWidget);
  });
}
