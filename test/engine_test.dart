
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/features/triage/models.dart';
import '../lib/features/triage/engine.dart';

void main() {
  final engine = Engine(const I18n(Locale('pt')));

  CaseData caso({
    bool hemExs = false,
    bool deambula = false,
    bool respIni = true,
    bool respPos = true,
    int fr = 20,
    double tec = 1.5,
    bool obedece = true,
  }) {
    return CaseData(
      idade: 35,
      sexo: Sex.male,
      hemExs: hemExs,
      deambula: deambula,
      respIni: respIni,
      respPos: respPos,
      fr: fr,
      tecSec: tec,
      obedece: obedece,
      lesao: 'Fratura fechada',
      gestante: 'NÃO',
      idoso: false,
    );
  }

  TriageColor classificar(
    CaseData c, {
    bool torniquete = true,
    bool viasAereas = true,
  }) {
    return engine.decide(
      c,
      tourniquet: torniquete,
      airwayOpened: viasAereas,
    ).color;
  }

  group('Classificações básicas', () {
    test('Deambula: VERDE', () {
      expect(classificar(caso(deambula: true)), TriageColor.green);
    });

    test('Estável e não deambula: AMARELO', () {
      expect(classificar(caso()), TriageColor.yellow);
    });

    test('Não obedece comandos: VERMELHO', () {
      expect(classificar(caso(obedece: false)), TriageColor.red);
    });

    test('Apneia persistente após abrir vias aéreas: PRETO', () {
      expect(
        classificar(caso(respIni: false, respPos: false, fr: 0)),
        TriageColor.black,
      );
    });

    test('Volta a respirar após abrir vias aéreas: VERMELHO', () {
      expect(
        classificar(caso(respIni: false, respPos: true)),
        TriageColor.red,
      );
    });
  });

  group('Limites de frequência respiratória', () {
    for (final fr in [9, 10, 30, 31]) {
      test('FR $fr rpm', () {
        final esperado =
            fr < 10 || fr > 30 ? TriageColor.red : TriageColor.yellow;

        expect(classificar(caso(fr: fr)), esperado);
      });
    }
  });

  group('Limites de TEC', () {
    for (final tec in [1.9, 2.0, 2.1]) {
      test('TEC $tec segundos', () {
        final esperado =
            tec > 2.0 ? TriageColor.red : TriageColor.yellow;

        expect(classificar(caso(tec: tec)), esperado);
      });
    }
  });

  group('Hemorragia exsanguinante', () {
    test('Sem torniquete: VERMELHO', () {
      expect(
        classificar(caso(hemExs: true), torniquete: false),
        TriageColor.red,
      );
    });

    test('Com torniquete e sinais estáveis: AMARELO', () {
      expect(
        classificar(caso(hemExs: true), torniquete: true),
        TriageColor.yellow,
      );
    });
  });
}
