import 'models.dart';

class RuleResult {
  final TriageColor color;
  final String explain;
  const RuleResult(this.color, this.explain);
}

class Engine {
  final I18n i18n;
  const Engine(this.i18n);

  RuleResult decide(
      CaseData c, {
        required bool tourniquet,
        required bool airwayOpened,
      }) {
    // 0) Hemorragia exsanguinante SEM torniquete → VERMELHO (prioridade absoluta)
    if (c.hemExs && !tourniquet) {
      return RuleResult(
        TriageColor.red,
        i18n.t(
          'Hemorragia exsanguinante sem torniquete → VERMELHO.',
          'Exsanguinating bleeding without tourniquet → RED.',
          'Hemorragia exanguinante sin torniquete → ROJO.',
        ),
      );
    }

    // 1) Deambula → VERDE (se chegou aqui, não há hemorragia exsanguinante sem TQ)
    if (c.deambula) {
      return RuleResult(
        TriageColor.green,
        i18n.t('Deambula → VERDE.', 'Walking → GREEN.', 'Deambula → VERDE.'),
      );
    }

    // 2) Não respira (inicial) → abrir VA (manobra de desobstrução)
    if (!c.respIni) {
      if (!airwayOpened) {
        return RuleResult(
          TriageColor.red,
          i18n.t(
            'Não respira inicialmente. Realize manobra de desobstrução / abra vias aéreas.',
            'Not breathing initially. Perform airway opening / clearance.',
            'No respira inicialmente. Realice maniobra de desobstrucción / abra la vía aérea.',
          ),
        );
      }
      if (!c.respPos) {
        return RuleResult(
          TriageColor.black,
          i18n.t(
            'Não respira após abrir vias aéreas → ÓBITO.',
            'No breathing after airway opening → BLACK.',
            'No respira tras abrir la vía aérea → NEGRO.',
          ),
        );
      }
      return RuleResult(
        TriageColor.red,
        i18n.t(
          'Respirou após abrir vias aéreas → VERMELHO.',
          'Breathes after airway opening → RED.',
          'Respira tras abrir la vía aérea → ROJO.',
        ),
      );
    }

    // 3) Respira → checar FR <10 ou >30
    if (c.fr < 10 || c.fr > 30) {
      return RuleResult(
        TriageColor.red,
        i18n.t(
          'FR < 10 rpm OU > 30 rpm → VERMELHO.',
          'RR < 10 breaths/min OR > 30 breaths/min → RED.',
          'FR < 10 rpm O > 30 rpm → ROJO.',
        ),
      );
    }

    // 4) Enchimento capilar ≥ 2 s
    if (c.tecSec.isInfinite || c.tecSec.isNaN || c.tecSec > 2.0) {
      return RuleResult(
        TriageColor.red,
        i18n.t(
          'Enchimento capilar > 2 s → VERMELHO.',
          'Capillary refill time > 2 s → RED.',
          'Tiempo de relleno capilar > 2 s → ROJO.',
        ),
      );
    }

    // 5) Obedece comandos?
    if (!c.obedece) {
      return RuleResult(
        TriageColor.red,
        i18n.t(
          'Não obedece comandos → VERMELHO.',
          'Does not obey commands → RED.',
          'No obedece órdenes → ROJO.',
        ),
      );
    }

    // 6) Estável, não deambulante
    return RuleResult(
      TriageColor.yellow,
      i18n.t(
        'Sinais estáveis, não deambula → AMARELO.',
        'Stable signs, non-ambulatory → YELLOW.',
        'Signos estables, no deambula → AMARILLO.',
      ),
    );
  }
}
