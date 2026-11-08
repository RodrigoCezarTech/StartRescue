import 'package:flutter/material.dart';

class FlowchartScreen extends StatelessWidget {
  const FlowchartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fluxograma START')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Fluxograma START\n\n(Imagem não incluída. '
                'Adicione assets/flowchart.png e habilite no pubspec.yaml para visualizar.)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
