import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'models.dart';
import 'csv_export.dart';
import 'pdf_export.dart';

class ResultsScreen extends StatelessWidget {
  final SessionForm form;
  final I18n i18n;
  final List<AnswerRow> rows;

  const ResultsScreen({
    super.key,
    required this.form,
    required this.i18n,
    required this.rows,
  });

  Future<void> _exportPdf(BuildContext context) async {
    try {
      final bytes = await buildResultsPdf(form, rows);
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'relatorio_startrescue.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar PDF: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv(BuildContext context) async {
    try {
      final csvContent = buildCsv(form, rows);
      final bytes = utf8.encode('\uFEFF$csvContent');
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            mimeType: 'text/csv',
            name: 'relatorio_startrescue.csv',
          ),
        ],
        fileNameOverrides: ['relatorio_startrescue.csv'],
        text: 'Dados do relatório StartRescue',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar CSV: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final correct = rows.where((r) => r.sua == r.correta).length;
    final percent = rows.isEmpty ? 0 : (correct / rows.length * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.t(
                'Triagem Concluída',
                'Triage Complete',
                'Triaje completado',
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('Total de casos: ${rows.length}'),
            Text('Acertos: $correct ($percent%)'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _exportPdf(context),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Exportar PDF'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _exportCsv(context),
              icon: const Icon(Icons.table_chart),
              label: const Text('Exportar CSV'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).popUntil(
                    (route) => route.isFirst,
              ),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
