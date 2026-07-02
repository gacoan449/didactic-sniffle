import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/main.dart' as aplikasi;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('✅ Alur Utama Aplikasi', () {
    testWidgets('Aplikasi dapat dimulai tanpa error', (tester) async {
      aplikasi.main();
      await tester.pumpAndSettle();
      expect(find.byType(Application), findsOneWidget);
    });
  });
}
