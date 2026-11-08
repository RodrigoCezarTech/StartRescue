import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'models.dart';

PdfColor _pdfBg(TriageColor c) {
  switch (c) {
    case TriageColor.green:  return const PdfColor.fromInt(0xFF2E7D32);
    case TriageColor.yellow: return const PdfColor.fromInt(0xFFF2A900);
    case TriageColor.red:    return const PdfColor.fromInt(0xFFD32F2F);
    case TriageColor.black:  return PdfColors.black;
  }
}
PdfColor _pdfFg(TriageColor c) => c == TriageColor.yellow ? PdfColors.black : PdfColors.white;


pw.Widget _cell(String text, {PdfColor? bg, PdfColor? fg}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 6,
    ),
    color: bg,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        color: fg ?? PdfColors.black,
        fontSize: 10,
      ),
    ),
  );
}


Future<Uint8List> buildResultsPdf(SessionForm form, List<AnswerRow> rows) async {

  final fontData = await rootBundle.load(
    'assets/fonts/NotoSans-Regular.ttf',
  );

  final notoSans = pw.Font.ttf(fontData);

  final doc = pw.Document(
    theme: pw.ThemeData.withFont(
      base: notoSans,
      bold: notoSans,
    ),
  );
  final correct = rows.where((r) => r.sua == r.correta).length;
  final percent = rows.isEmpty ? 0 : (correct / rows.length * 100).round();

  final headerStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white);

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: const PdfColor.fromInt(0xFF7C4DFF),
          child: pw.Text('Método START - Resultado', style: headerStyle.copyWith(fontSize: 18)),        ),
        pw.SizedBox(height: 6),
        pw.Text('Aluno: ${form.name}   Setor: ${form.sector}   ID: ${form.id}'),
        pw.SizedBox(height: 4),
        pw.Text('Acertos: $correct / ${rows.length}  ($percent%)'),
        pw.SizedBox(height: 10),

        // Tabela customizada com cores
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.3),
          columnWidths: {
            0: const pw.FixedColumnWidth(32),
            1: const pw.FixedColumnWidth(68),
            2: const pw.FixedColumnWidth(68),
            3: const pw.FlexColumnWidth(),
            4: const pw.FixedColumnWidth(34),
            5: const pw.FixedColumnWidth(28),
            6: const pw.FixedColumnWidth(28),
            7: const pw.FixedColumnWidth(38),
            8: const pw.FixedColumnWidth(40),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cell('Q'), _cell('Correta'), _cell('Sua'), _cell('Explicação'),
                _cell('Id.'), _cell('S.'), _cell('FR'), _cell('TEC'), _cell('Cmd.'),
              ].map((w) => pw.Container(child: w)).toList(),
            ),
            ...rows.map((r) {
              final sua = r.sua;
              final bgCorreta = _pdfBg(r.correta);
              final fgCorreta = _pdfFg(r.correta);
              final bgSua     = sua == null ? null : _pdfBg(sua);
              final fgSua     = sua == null ? null : _pdfFg(sua);

              return pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.full,
                  children: [                _cell('${r.q}'),
                _cell(r.correta.name.toUpperCase(), bg: bgCorreta, fg: fgCorreta),
                _cell(sua?.name.toUpperCase() ?? '', bg: bgSua, fg: fgSua),
                _cell(
                  r.explicacao
                      .replaceAll('→', '->')
                      .replaceAll('≥', '>=')
                      .replaceAll('≤', '<='),
                ),                _cell('${r.data.idade}'),
                _cell(r.data.sexo == Sex.male ? 'M' : 'F'),
                _cell('${r.data.fr}'),
                _cell(
                  r.data.tecSec.isInfinite
                      ? 'INF'
                      : r.data.tecSec.toStringAsFixed(1),
                ),                _cell(r.data.obedece ? 'SIM' : 'NÃO'),
              ]);
            }),
          ],
        ),
      ],
    ),
  );

  return doc.save();
}
