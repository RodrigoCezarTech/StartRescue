// results_screen.dart

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

// Importações necessárias
import 'models.dart';
import 'csv_export.dart';

class ResultsScreen extends StatelessWidget {
  // CAMPOS OBRIGATÓRIOS (Passados da TriageScreen)
  final SessionForm form;
  final I18n i18n;
  final List<AnswerRow> rows;
  final File pdfFile;

  const ResultsScreen({
    required this.form,
    required this.i18n,
    required this.rows,
    required this.pdfFile,
    Key? key
  }) : super(key: key);

  // FUNÇÃO DE EXPORTAR PDF E COMPARTILHAR (Chamada pelo botão)
  Future<void> _exportAndSharePdf(BuildContext context) async {
    // Usa share_plus para abrir o menu de compartilhamento (e-mail, WhatsApp, Salvar em Arquivos, etc.)
    await Share.shareXFiles([XFile(pdfFile.path)], text: 'Relatório StartRescue (PDF)');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relatório PDF exportado e pronto para compartilhamento!')),
      );
    }
  }

  // FUNÇÃO DE EXPORTAR CSV E COMPARTILHAR (Chamada pelo botão)

  // Exporta e compartilha o CSV com os resultados reais.
  Future<void> _exportAndShareCsv(BuildContext context) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      final File csvFile = File(
        '${tempDir.path}/relatorio_dados_${DateTime.now().millisecondsSinceEpoch}.csv',
      );

      final String csvContent = buildCsv(form, rows);

      await csvFile.writeAsString(
        csvContent,
        encoding: utf8,
        flush: true,
      );

      await Share.shareXFiles(
        [XFile(csvFile.path)],
        text: 'Dados do Relatório StartRescue (CSV)',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar CSV: $e')),
        );
      }
    }
  }


  // O método _openPostExportModal (que gerava o modal de e-mail) foi COMPLETAMENTE REMOVIDO.

  @override
  Widget build(BuildContext context) {
    final correct = rows.where((r) => r.sua == r.correta).length;
    final percent = rows.isEmpty ? 0 : (correct / rows.length * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e Estatísticas
            Text(
                i18n.t('Triagem Concluída', 'Triage Complete', 'Triage Complete'),
                style: Theme.of(context).textTheme.headlineMedium
            ),
            const SizedBox(height: 8),
            Text('${i18n.t('Total de Casos', 'Total Cases', 'Casos Totales')}: ${rows.length}'),
            Text('${i18n.t('Acertos', 'Correct Answers', 'Respuestas Correctas')}: $correct (${percent}%)'),

            const Spacer(),

            // 1. BOTÃO EXPORTAR PDF
            ElevatedButton.icon(
              onPressed: () => _exportAndSharePdf(context),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Exportar PDF'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
            const SizedBox(height: 12),

            // 2. BOTÃO EXPORTAR CSV
            OutlinedButton.icon(
              onPressed: () => _exportAndShareCsv(context),
              icon: const Icon(Icons.table_chart),
              label: const Text('Exportar CSV'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),

            const SizedBox(height: 12),

            // 3. BOTÃO VOLTAR AO INÍCIO
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}