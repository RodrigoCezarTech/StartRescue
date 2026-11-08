import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'core/theme_controller.dart';
import 'features/home/home_screen.dart';

class StartRescueApp extends StatelessWidget {
  const StartRescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Método START',
          debugShowCheckedModeBanner: false,

          // i18n
          locale: ThemeController.instance.locale,
          supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // tema
          themeMode: ThemeController.instance.mode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // home
          home: HomeScreen(
            onToggleTheme: ThemeController.instance.toggleTheme,
            onChangeLocale: ThemeController.instance.setLocale,
          ),
        );
      },
    );
  }
}
