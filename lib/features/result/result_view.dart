import 'package:flutter/material.dart';
import '../../services/export_service.dart';

class ResultView extends StatefulWidget {
  const ResultView({
    super.key,
    required this.i18n,   // Map<String,String> é suficiente
    required this.form,
    required this.rows,
  });

  final Map<String, String>? i18n;
  final dynamic form;
  final List<dynamic> rows;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final _emailCtrl = TextEditingController();

  String _fileName() {
    String s(String v) => v.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '_');
    final n = s('${widget.form?.nome ?? 'start'}');
    final sset = s('${widget.form?.setor ?? 'rescue'}');
    final id = s('${widget.form?.id ?? '0001'}');
    return '${n}_${sset}_$id';
  }

  String _t(String k, String f) =>
      (widget.i18n != null && widget.i18n![k]?.trim().isNotEmpty == true)
          ? widget.i18n![k]!
          : f;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_t('resultTitle', 'Resultado'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${widget.form?.nome ?? 'método start'}  |  ${widget.form?.setor ?? 'rescue'}  |  ${widget.form?.id ?? '0001'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: _t('emailForSend', 'E-mail para envio'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await ExportService.sharePdf(
                  name: _fileName(),
                  form: widget.form,
                  results: widget.rows,
                  i18n: widget.i18n,
                );
              },
              child: Text(_t('sendPdfByEmail', 'Enviar PDF por e-mail')),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final f = await ExportService.exportCsv(
                        name: _fileName(),
                        form: widget.form,
                        results: widget.rows,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('CSV salvo em ${f.path}')),
                      );
                    },
                    child: Text(_t('exportCsv', 'Exportar CSV')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final f = await ExportService.exportPdf(
                        name: _fileName(),
                        form: widget.form,
                        results: widget.rows,
                        i18n: widget.i18n,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('PDF salvo em ${f.path}')),
                      );
                    },
                    child: Text(_t('exportPdf', 'Exportar PDF')),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(_t('backToStart', 'Voltar ao início')),
            ),
          ],
        ),
      ),
    );
  }
}
