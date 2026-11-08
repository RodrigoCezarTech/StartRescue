// lib/features/triage/pdf_export.dart
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

// models.dart está na MESMA pasta de pdf_export.dart
import '../features/triage/models.dart';

class ExportService {
  ExportService._();

  // ===================== CSV =====================
  static Future<File> exportCsv({
    required String name,
    required dynamic form,
    required List<dynamic> results,
  }) async {
    final sb = StringBuffer();
    sb.writeln('método start | ${form?.setor ?? ''} | ${form?.id ?? ''}');
    sb.writeln('Q;Id;Sx;Hem;TQ;Deamb;RIni;RPos;FR;TEC;Obed;Gest;Lesão;Sua;Correta;Explicação');

    for (final r in results) {
      if (r is Map) {
        sb.writeln([
          r['q'] ?? '',
          r['id'] ?? '',
          r['sx'] ?? '',
          r['hem'] ?? '',
          r['tq'] ?? '',
          r['deamb'] ?? '',
          r['rIni'] ?? '',
          r['rPos'] ?? '',
          r['fr'] ?? '',
          r['tec'] ?? '',
          r['obed'] ?? '',
          r['gest'] ?? '',
          r['lesao'] ?? '',
          r['sua'] ?? '',
          r['correta'] ?? '',
          r['explicacao'] ?? '',
        ].join(';'));
      } else {
        sb.writeln(r.toString());
      }
    }

    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$name.csv');
    return file.writeAsString(sb.toString(), flush: true);
  }

  // ===================== PDF =====================
  static Future<File> exportPdf({
    required String name,
    required dynamic form,
    required List<dynamic> results,
    Map<String, String>? i18n,
  }) async {
    String pick(String k, String fallback) =>
        (i18n != null && (i18n[k]?.trim().isNotEmpty ?? false)) ? i18n![k]! : fallback;

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        header: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              pick('resultTitle', 'Resultado'),
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              '${form?.nome ?? 'método start'} | ${form?.setor ?? ''} | ${form?.id ?? ''}',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 12),
          ],
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${ctx.pageNumber}/${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        build: (_) => [
          _resultTable(results),
        ],
      ),
    );

    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(await doc.save(), flush: true);
    return file;
  }

  static Future<void> sharePdf({
    required String name,
    required dynamic form,
    required List<dynamic> results,
    Map<String, String>? i18n,
  }) async {
    final f = await exportPdf(name: name, form: form, results: results, i18n: i18n);
    await Share.shareXFiles([XFile(f.path)], text: name);
  }

  // ---------- tabela ----------
  static pw.Widget _resultTable(List<dynamic> rows) {
    final headers = <String>[
      'Q','Id','Sx','Hem','TQ','Deamb','RIni','RPos','FR','TEC','Obed','Gest','Lesão','Sua','Correta','Explicação'
    ];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows.map<List<String>>((r) {
        if (r is Map) {
          return [
            '${r['q'] ?? ''}',
            '${r['id'] ?? ''}',
            '${r['sx'] ?? ''}',
            '${r['hem'] ?? ''}',
            '${r['tq'] ?? ''}',
            '${r['deamb'] ?? ''}',
            '${r['rIni'] ?? ''}',
            '${r['rPos'] ?? ''}',
            '${r['fr'] ?? ''}',
            '${r['tec'] ?? ''}',
            '${r['obed'] ?? ''}',
            '${r['gest'] ?? ''}',
            '${r['lesao'] ?? ''}',
            '${r['sua'] ?? ''}',
            '${r['correta'] ?? ''}',
            '${r['explicacao'] ?? ''}',
          ];
        }
        return [r.toString()];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerDecoration: pw.BoxDecoration(color: pdf.PdfColor.fromInt(0xFFEDE7F6)),
      rowDecoration: pw.BoxDecoration(color: pdf.PdfColor.fromInt(0xFFFFFFFF)),
      oddRowDecoration: pw.BoxDecoration(color: pdf.PdfColor.fromInt(0xFFF7F7F7)),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: const {
        0: pw.FlexColumnWidth(1),  // Q
        12: pw.FlexColumnWidth(3), // Lesão
        15: pw.FlexColumnWidth(3), // Explicação
      },
    );
  }

  // Cores START no PDF (caso você queira pintar texto/célula depois)
  static pdf.PdfColor triagePdfBg(TriageColor c) {
    switch (c) {
      case TriageColor.green:  return pdf.PdfColor.fromInt(0xFF2E7D32);
      case TriageColor.yellow: return pdf.PdfColor.fromInt(0xFFF2A900);
      case TriageColor.red:    return pdf.PdfColor.fromInt(0xFFC62828);
      case TriageColor.black:  return pdf.PdfColor.fromInt(0xFF000000);
    }
  }

  static pdf.PdfColor triagePdfFg(TriageColor c) {
    switch (c) {
      case TriageColor.yellow: return pdf.PdfColor.fromInt(0xFF000000);
      default:                 return pdf.PdfColor.fromInt(0xFFFFFFFF);
    }
  }
}
