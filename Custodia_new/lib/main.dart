import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:custodiaa/core/theme/app_theme.dart';
import 'package:custodiaa/core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const CustodiaApp());
}

class CustodiaApp extends StatelessWidget {
  const CustodiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custodia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
