import 'package:flutter/material.dart';

/// Singleton bem simples para tema + idioma.
/// Mantém ValueNotifiers para rebuild automático via ValueListenableBuilder
/// (ou só chamando setState após toggles).
class ThemeController {
  ThemeController._();
  static final instance = ThemeController._();

  // Estado
  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('pt', 'BR'));

  void toggleTheme() {
    mode.value = mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setLocale(Locale l) {
    locale.value = l;
  }
}
