import 'package:flutter/material.dart';
import '../triage/models.dart';

Future<void> showFlowchartDialog(BuildContext context, I18n i18n) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(i18n.flowchart),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Flexible(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.asset(
                'assets/images/flowchart.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Fluxograma não encontrado (assets/images/flowchart.png)'),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
