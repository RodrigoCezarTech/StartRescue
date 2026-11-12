
// triage_screen.dart

import 'package:flutter/material.dart';

import 'models.dart';
import 'triage_controller.dart';
import 'results_screen.dart';

class TriageScreen extends StatefulWidget {
final SessionForm form;
final VoidCallback onToggleTheme;
final ValueChanged<Locale> onChangeLocale;

const TriageScreen({
super.key,
required this.form,
required this.onToggleTheme,
required this.onChangeLocale,
});

@override
State<TriageScreen> createState() => _TriageScreenState();
}

class _TriageScreenState extends State<TriageScreen> {
TriageController? _ctrl;

@override
void didChangeDependencies() {
super.didChangeDependencies();
final loc = Localizations.localeOf(context);
// Assumindo que I18n está disponível
final i18n = I18n(loc);

if (_ctrl == null) {
_ctrl = TriageController(i18n, widget.form);
_ctrl!.startTimer(() {
if (mounted && !_finishing) setState(() {});
}, _onTimeUp);
} else {
_ctrl!.setLocale(loc);
}
}

@override
void dispose() {
_ctrl?.stopTimer();
super.dispose();
}

bool _finishing = false;

void _onTimeUp() {
if (!mounted || _finishing) return;
_goNext();
}

void _goNext() {
if (!mounted || _finishing) return;

final ctrl = _ctrl!;
if (ctrl.index >= ctrl.cases.length) return;

final hasMore = ctrl.next();
if (!hasMore) {
_finishing = true;
ctrl.stopTimer();

final i18n = I18n(Localizations.localeOf(context));
Navigator.of(context).pushReplacement(
MaterialPageRoute(
builder: (_) => ResultsScreen(
form: widget.form,
i18n: i18n,
rows: List.of(ctrl.answers),
),
),
);
return;
}

setState(() {});
ctrl.startTimer(
() {
if (mounted && !_finishing) setState(() {});
},
_onTimeUp,
);
}

void _tryAnswer(TriageColor color) {
final i18n = I18n(Localizations.localeOf(context));
final ctrl = _ctrl!;
if (_finishing || ctrl.index >= ctrl.cases.length) return;
final c = ctrl.cases[ctrl.index];

// Exige controle de hemorragia exsanguinante.
if (c.hemExs && !ctrl.tourniquet) {
ScaffoldMessenger.of(context).removeCurrentSnackBar();
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(i18n.mustApplyTourniquet),
duration: const Duration(seconds: 1),
),
);
return;
}

// Exige abertura das vias aéreas quando não há respiração inicial.
if (!c.respIni && !ctrl.airwayOpened) {
ScaffoldMessenger.of(context).removeCurrentSnackBar();
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
i18n.t(
'Abra as vias aéreas antes de classificar a vítima.',
'Open the airway before classifying the victim.',
'Abra la vía aérea antes de clasificar a la víctima.',
),
),
duration: const Duration(seconds: 1),
),
);
return;
}

setState(() => ctrl.answer(color));
}


@override
Widget build(BuildContext context) {
final i18n = I18n(Localizations.localeOf(context));
final ctrl = _ctrl!;
final c = ctrl.cases[ctrl.index];
final page = ctrl.pageLabel;
final rule = ctrl.currentRule();

return Scaffold(
appBar: AppBar(
title: Text(i18n.appTitle),
leading: IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: () => Navigator.of(context).maybePop(),
),
actions: [
IconButton(
tooltip: i18n.light,
onPressed: widget.onToggleTheme,
icon: const Icon(Icons.brightness_6_outlined),
),
PopupMenuButton<Locale>(
tooltip: i18n.language,
icon: const Icon(Icons.language),
onSelected: (loc) {
widget.onChangeLocale(loc);
_ctrl!.setLocale(loc);
setState(() {});
},
itemBuilder: (_) => const [
PopupMenuItem(value: Locale('pt'), child: Text('Português')),
PopupMenuItem(value: Locale('en'), child: Text('English')),
PopupMenuItem(value: Locale('es'), child: Text('Español')),
],
),
TextButton(
onPressed: () {
setState(() => ctrl.openAirway());

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(i18n.airwayOpenedMsg),
duration: const Duration(seconds: 1),
),
);

},
child: Text(i18n.openAirway, style: const TextStyle(color: Colors.white)),
),
TextButton(
onPressed: () {
final caseData = c;

if (!caseData.hemExs) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(i18n.noExsanguinatingHere),
duration: const Duration(seconds: 1),
),
);
return;
}

final applied = ctrl.applyTourniquet();
setState(() {});
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
applied
? i18n.tourniquetAppliedNowClassify
    : i18n.tourniquetAlreadyApplied,
),
duration: const Duration(seconds: 1),
),
);
},
child: Text(i18n.applyTourniquet, style: const TextStyle(color: Colors.white)),
),
],
),
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
// cabeçalho
Text('${i18n.caseTitle}  •  $page  •  ${ctrl.secondsLeft}s',
style: Theme.of(context).textTheme.titleMedium),

if (ctrl.airwayOpened || ctrl.tourniquet) ...[
const SizedBox(height: 8),
Wrap(
spacing: 8,
children: [
if (ctrl.airwayOpened) Chip(label: Text(i18n.airwayOpenedMsg)),
if (ctrl.tourniquet) Chip(label: Text(i18n.tourniquetAppliedNowClassify)),
],
),
],
const SizedBox(height: 8),

// Conteúdo rolável
Expanded(
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
_CaseCard(i18n: i18n, data: c, airwayOpened: ctrl.airwayOpened),
const SizedBox(height: 12),

Wrap(
spacing: 12,
runSpacing: 12,
children: [
_ColorButton(color: TriageColor.green,  i18n: i18n, onTap: () => _tryAnswer(TriageColor.green)),
_ColorButton(color: TriageColor.yellow, i18n: i18n, onTap: () => _tryAnswer(TriageColor.yellow)),
_ColorButton(color: TriageColor.red,    i18n: i18n, onTap: () => _tryAnswer(TriageColor.red)),
_ColorButton(color: TriageColor.black,  i18n: i18n, onTap: () => _tryAnswer(TriageColor.black)),
],
),

if (ctrl.selected != null) ...[
const SizedBox(height: 12),
Text(
'${i18n.correctAnswer}: '
'${rule.color == ctrl.selected ? '✓' : '✗'}  ${rule.explain}',
),
],
const SizedBox(height: 12),
],
),
),
),

// Botão fixo
SafeArea(
top: false,
child: SizedBox(
height: 56,
child: ElevatedButton(
onPressed: _goNext,
style: ElevatedButton.styleFrom(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
),
child: Text(i18n.next),
),
),
),
],
),
),
),
);
}
}

/// ---------- UI helpers ----------

class _CaseCard extends StatelessWidget {
final I18n i18n;
final CaseData data;
final bool airwayOpened;
const _CaseCard({required this.i18n, required this.data, required this.airwayOpened});

String _sex(Sex s) => s == Sex.male
? i18n.t('Masculino', 'Male', 'Masculino')
    : i18n.t('Feminino', 'Female', 'Femenino');

String _yn(bool v) => v ? i18n.yes : i18n.no;

String _frText() {
if (!data.respIni && !airwayOpened) return '00';
if (!data.respIni && airwayOpened && !data.respPos) return '00';
return '${data.fr}';
}

String _tecText() {
final absent = i18n.t('ausente', 'absent', 'ausente');
if (!data.respIni && !airwayOpened) return absent;
if (!data.respIni && airwayOpened && !data.respPos) return absent;
return data.tecSec.isInfinite ? '∞' : data.tecSec.toStringAsFixed(1);
}

bool _obedeceDisplay() {
if (!data.respIni) return false;
if (!data.respIni && airwayOpened && data.respPos) return false;
return data.obedece;
}

@override
Widget build(BuildContext context) {
return Card(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(i18n.caseTitle, style: Theme.of(context).textTheme.titleLarge),
const SizedBox(height: 8),

_row(context, i18n.ageLabel, '${data.idade}   |   ${i18n.sexLabel}: ${_sex(data.sexo)}'),

// Gestante: só mostra para sexo feminino
if (data.sexo == Sex.female)
_row(context, i18n.pregnant, data.gestante),


// Idoso: mostra apenas quando verdadeiro
if (data.idoso)
_row(context, i18n.elderly, i18n.yes),

_row(context, i18n.exsang, _yn(data.hemExs)),
_row(context, i18n.walk, _yn(data.deambula)),
_row(context, i18n.breathInit, _yn(data.respIni)),
if (!data.respIni && airwayOpened)
_row(context, i18n.breathAfter, _yn(data.respPos)),
_row(context, 'FR', _frText()),
_row(context, 'TEC', _tecText()),
_row(context, i18n.obeys, _yn(_obedeceDisplay())),

// Lesões traduzidas via I18n
_row(context, i18n.injuries, i18n.lesionToLocale(data.lesao)),
],
),
),
);
}

Widget _row(BuildContext context, String k, String v) =>
Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('$k: $v'));
}

class _ColorButton extends StatelessWidget {
final TriageColor color;
final I18n i18n;
final VoidCallback onTap;
const _ColorButton({required this.color, required this.i18n, required this.onTap});

@override
Widget build(BuildContext context) {
return SizedBox(
width: (MediaQuery.of(context).size.width - 12 * 3) / 2,
height: 52,
child: ElevatedButton(
onPressed: onTap,
style: ElevatedButton.styleFrom(
backgroundColor: color.color(),
foregroundColor: color.fg(),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: Text(color.label(i18n.lang)),
),
);
}
}