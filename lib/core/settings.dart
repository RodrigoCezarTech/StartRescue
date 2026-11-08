import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

/// true = Dark, false = Light
final themeDarkProvider = StateProvider<bool>((_) => true);

/// true = Português, false = Inglês
final langPtProvider = StateProvider<bool>((_) => true);

/// Conveniência: ThemeMode a partir do provider
final themeModeProvider = Provider<ThemeMode>(
      (ref) => ref.watch(themeDarkProvider) ? ThemeMode.dark : ThemeMode.light,
);
