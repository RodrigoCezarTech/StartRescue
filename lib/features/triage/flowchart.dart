import 'package:flutter/material.dart';

const String kFlowchartPrimary = 'assets/images/flowchart.png';
const String kFlowchartFallback = 'assets/images/flowchart.png';


class FlowchartScreen extends StatelessWidget {
  const FlowchartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Fluxograma START')),
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F3FC),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: _FlowchartBody(),
      ),
    );
  }
}

class FlowchartDialog extends StatelessWidget {
  const FlowchartDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: isDark ? const Color(0xFF201F24) : const Color(0xFFF5EEF9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 1000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Fluxograma START',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Expanded(child: _FlowchartBody()),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowchartBody extends StatelessWidget {
  const _FlowchartBody();

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.6,
      maxScale: 3.5,
      child: Image.asset(
        kFlowchartPrimary,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Image.asset(kFlowchartFallback, fit: BoxFit.contain,
              errorBuilder: (c, _, __) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Imagem do fluxograma não encontrada.\n'
                        'Adicione em assets/images/ e habilite no pubspec.yaml.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
