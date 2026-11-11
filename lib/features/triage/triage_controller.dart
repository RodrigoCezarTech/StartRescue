import 'dart:async';
import 'dart:ui';

import 'models.dart';
import 'engine.dart';
import 'generator.dart';

class TriageController {
  // i18n é mutável para podermos trocar o idioma em tempo real
  I18n i18n;
  final SessionForm form;
  late Engine engine;

  // Casos gerados e respostas registradas
  late final List<CaseData> cases = generateCases();
  final List<AnswerRow> answers = [];

  // Estado da rodada
  int index = 0;
  bool airwayOpened = false;
  bool tourniquet = false;
  TriageColor? selected;
  int secondsLeft;            // <<< não-nulo (inicializado no construtor)
  Timer? _timer;

  TriageController(this.i18n, this.form)
      : secondsLeft = form.timeLimitSec {
    engine = Engine(i18n);
  }

  /// Troca o idioma do controller (chamado quando o usuário escolhe PT/EN/ES)
  void setLocale(Locale loc) {
    i18n = I18n(loc);
    engine = Engine(i18n);
  }

  // ----------------- Timer -----------------

  void startTimer(
      void Function() onTick,
      void Function() onTimeUp,
      ) {
    _timer?.cancel();
    secondsLeft = form.timeLimitSec;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (secondsLeft <= 1) {
          secondsLeft = 0;
          timer.cancel();
          onTick();
          onTimeUp();
          return;
        }

        secondsLeft--;
        onTick();
      },
    );
  }


  void stopTimer() => _timer?.cancel();

  // ----------------- Ações -----------------
  void openAirway() => airwayOpened = true;
  bool applyTourniquet() {
    if (tourniquet) return false; // já aplicado
    tourniquet = true;
    return true;
  }

  String get pageLabel {
    final cur = (index + 1).toString().padLeft(2, '0');
    final total = form.total.toString().padLeft(2, '0');
    return '$cur/$total';
  }

  RuleResult currentRule() =>
      engine.decide(cases[index],
          tourniquet: tourniquet, airwayOpened: airwayOpened);

  void answer(TriageColor color) {
    selected = color;
    stopTimer(); // para o cronômetro ao responder
  }

  bool next() {
    if (index >= cases.length) {
      return false;
    }

    final rule = engine.decide(
      cases[index],
      tourniquet: true,
      airwayOpened: true,
    );
    answers.add(AnswerRow(
      q: index + 1,
      correta: rule.color,
      sua: selected,
      explicacao: rule.explain,
      data: cases[index],
    ));

    index++;
    airwayOpened = false;
    tourniquet = false;
    selected = null;
    secondsLeft = form.timeLimitSec;

    return index < cases.length;
  }

  int get correctCount => answers.where((a) => a.sua == a.correta).length;
}
