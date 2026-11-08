import 'package:flutter/material.dart';

const _seed = Color(0xFF8F79FF); // lilás base

final ColorScheme _baseLight = ColorScheme.fromSeed(
  seedColor: _seed,
  brightness: Brightness.light,
  surface: const Color(0xFFF6F3FA),
  onSurface: const Color(0xFF1D1B20),
);

final ColorScheme _baseDark = ColorScheme.fromSeed(
  seedColor: _seed,
  brightness: Brightness.dark,
  surface: const Color(0xFF151217),
  onSurface: const Color(0xFFEAE6EF),
);

ThemeData _shared(ColorScheme scheme) {
  final on = scheme.onSurface;

  // Se sua versão do Flutter não tiver `surfaceContainer`,
  // troque por `scheme.surfaceVariant`.
  final container = scheme.surfaceContainer;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surface,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
      actionsIconTheme: IconThemeData(color: on.withOpacity(.85)),
      iconTheme: IconThemeData(color: on.withOpacity(.85)),
    ),

    // <-- AQUI era o erro: use CardThemeData em vez de CardTheme
    cardTheme: CardThemeData(
      color: container,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      labelStyle: TextStyle(
        color: on.withOpacity(.90),
        fontSize: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: on.withOpacity(.25), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: scheme.onPrimary,
        backgroundColor: scheme.primary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: on.withOpacity(.30), width: 1.2),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

ThemeData get lightTheme => _shared(_baseLight);
ThemeData get darkTheme  => _shared(_baseDark);
