
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/features/triage/models.dart';
import '../lib/features/triage/triage_controller.dart';

void main() {
  TriageController criarController() {
    return TriageController(
      const I18n(Locale('pt')),
      const SessionForm(
        name: 'Teste',
        sector: 'Simulação',
        id: '001',
        total: 20,
        timeLimitSec: 30,
      ),
    );


testWidgets('Cronômetro encerra em zero sem alterar a próxima rodada',
    (WidgetTester tester) async {
  final ctrl = criarController();

  int encerramentos = 0;
  int atualizacoes = 0;

  ctrl.startTimer(
    () => atualizacoes++,
    () {
      encerramentos++;
      ctrl.next();
      ctrl.startTimer(
        () => atualizacoes++,
        () => encerramentos++,
      );
    },
  );

  await tester.pump(
    Duration(seconds: ctrl.form.timeLimitSec),
  );

  expect(encerramentos, 1);
  expect(ctrl.index, 1);
  expect(ctrl.secondsLeft, ctrl.form.timeLimitSec);
  expect(atualizacoes, greaterThan(0));

  ctrl.stopTimer();
});




  }

  test('Inicia com 20 casos e nenhuma resposta', () {
    final ctrl = criarController();

    expect(ctrl.cases.length, 20);
    expect(ctrl.answers, isEmpty);
    expect(ctrl.index, 0);
    expect(ctrl.correctCount, 0);
  });

  test('Sem resposta não contabiliza acerto', () {
    final ctrl = criarController();

    ctrl.next();

    expect(ctrl.answers.length, 1);
    expect(ctrl.answers.first.sua, isNull);
    expect(ctrl.correctCount, 0);
  });

  test('Resposta correta contabiliza um acerto', () {
    final ctrl = criarController();

    final correta = ctrl.engine.decide(
      ctrl.cases[0],
      tourniquet: true,
      airwayOpened: true,
    ).color;

    ctrl.answer(correta);
    ctrl.next();

    expect(ctrl.correctCount, 1);
  });

  test('Avançar reinicia intervenções e seleção', () {
    final ctrl = criarController();

    ctrl.openAirway();
    ctrl.applyTourniquet();
    ctrl.answer(TriageColor.red);

    ctrl.next();

    expect(ctrl.index, 1);
    expect(ctrl.airwayOpened, false);
    expect(ctrl.tourniquet, false);
    expect(ctrl.selected, isNull);
    expect(ctrl.secondsLeft, 30);
  });

  test('Registra 20 respostas e encerra a sessão', () {
    final ctrl = criarController();

    bool hasMore = true;

    for (int i = 0; i < 20; i++) {
      hasMore = ctrl.next();
    }

    expect(ctrl.answers.length, 20);
    expect(ctrl.index, 20);
    expect(hasMore, false);
    expect(ctrl.correctCount, 0);
  });


  testWidgets(
    'Cronômetro não interfere na próxima rodada',
    (WidgetTester tester) async {
      final ctrl = criarController();

      int encerramentos = 0;

      ctrl.startTimer(
        () {},
        () {
          encerramentos++;
          ctrl.next();

          ctrl.startTimer(
            () {},
            () => encerramentos++,
          );
        },
      );

      await tester.pump(
        Duration(seconds: ctrl.form.timeLimitSec),
      );

      expect(encerramentos, 1);
      expect(ctrl.index, 1);
      expect(ctrl.secondsLeft, ctrl.form.timeLimitSec);

      ctrl.stopTimer();
    },
  );


}
