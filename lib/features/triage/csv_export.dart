import 'models.dart';

String _fmt(bool v) => v ? 'SIM' : 'NÃO';

String buildCsv(SessionForm form, List<AnswerRow> rows) {
  final b = StringBuffer();
  b.writeln('aluno;setor;id;total');
  b.writeln('${form.name};${form.sector};${form.id};${form.total}');
  b.writeln('q;correta;sua;explicacao;idade;sexo;hemExs;deambula;respIni;respPos;fr;tec;obedece;lesao');
  for (final r in rows) {
    final d = r.data;
    final sexo = d.sexo == Sex.male ? 'M' : 'F';
    b.writeln('${r.q};${r.correta.name};${r.sua?.name ?? ''};${r.explicacao};'
              '${d.idade};$sexo;${_fmt(d.hemExs)};${_fmt(d.deambula)};'
              '${_fmt(d.respIni)};${_fmt(d.respPos)};${d.fr};${d.tecSec};'
              '${_fmt(d.obedece)};${d.lesao.replaceAll(';', ',')}');
  }
  return b.toString();
}
