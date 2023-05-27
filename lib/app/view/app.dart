import 'package:bot_main_app/features/counter/counter.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(color: AppColors.primaryGreen),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: AppColors.primaryGreen,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
