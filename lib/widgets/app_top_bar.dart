import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    required this.onToggleTheme,
    required this.onChangeLocale,
    this.onShowAbout,           // ← AGORA OPCIONAL
    this.onShowFlowchart,       // ← OPCIONAL
    this.locale = const Locale('pt', 'BR'),
    this.showFlowchart = false,
  });

  final String title;
  final VoidCallback onToggleTheme;
  final void Function(Locale) onChangeLocale;
  final VoidCallback? onShowAbout;
  final VoidCallback? onShowFlowchart;
  final Locale locale;
  final bool showFlowchart;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<Locale>(
          tooltip: 'Idioma / Language',
          icon: const Icon(Icons.language),
          onSelected: onChangeLocale,
          itemBuilder: (context) => const [
            PopupMenuItem(value: Locale('pt', 'BR'), child: Text('Português (Brasil)')),
            PopupMenuItem(value: Locale('en', 'US'), child: Text('English (US)')),
          ],
        ),
        if (showFlowchart && onShowFlowchart != null)
          IconButton(
            tooltip: 'Fluxograma START',
            onPressed: onShowFlowchart,
            icon: const Icon(Icons.account_tree_outlined),
          ),
        if (onShowAbout != null)
          IconButton(
            tooltip: 'Sobre',
            onPressed: onShowAbout,
            icon: const Icon(Icons.info_outline),
          ),
        IconButton(
          tooltip: isDark ? 'Modo claro' : 'Modo escuro',
          onPressed: onToggleTheme,
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        ),
      ],
    );
  }
}
