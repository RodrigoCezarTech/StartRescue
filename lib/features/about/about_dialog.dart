import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutStartDialog extends StatelessWidget {
  const AboutStartDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog(
    context: context,
    builder: (_) => const AboutStartDialog(),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sobre o aplicativo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Aplicativo educativo para treinamento do método START.\n'
                'Sem coleta de dados sensíveis.',
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => launchUrl(
              Uri.parse('https://seu-dominio-ou-github/politica'),
              mode: LaunchMode.externalApplication,
            ),
            child: const Text(
              'Política de Privacidade',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
      ],
    );
  }
}
