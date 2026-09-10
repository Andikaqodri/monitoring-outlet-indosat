import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_theme.dart';
import 'package:custodiaa/presentation/pages/login/login_page.dart';

void main() {
  testWidgets('Custodia App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: const LoginPage(),
    ));
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
