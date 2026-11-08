import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/home/home_screen.dart';

void main() => runApp(const StartRescueApp());

class StartRescueApp extends StatefulWidget {
  const StartRescueApp({super.key});
  @override
  State<StartRescueApp> createState() => _StartRescueAppState();
}

class _StartRescueAppState extends State<StartRescueApp> {
  ThemeMode _mode = ThemeMode.dark;
  Locale _locale = const Locale('pt');

  void _toggleTheme() =>
      setState(() => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  void _changeLocale(Locale next) => setState(() => _locale = next);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Método START',
      themeMode: _mode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(primary: Color(0xFF7C4DFF)),
        useMaterial3: true,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(primary: Color(0xFF7C4DFF)),
        useMaterial3: true,
      ),

      // 🔑 Delegates e idiomas suportados
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
      locale: _locale,

      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        onChangeLocale: _changeLocale,
      ),
    );
  }
}
