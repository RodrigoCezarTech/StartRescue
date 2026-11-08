import 'package:flutter/material.dart';

enum Sex { male, female }
enum TriageColor { green, yellow, red, black }

extension TriageColorX on TriageColor {
  String label(String lang) {
    switch (this) {
      case TriageColor.green:
        return lang == 'pt' ? 'VERDE' : (lang == 'es' ? 'VERDE' : 'GREEN');
      case TriageColor.yellow:
        return lang == 'pt' ? 'AMARELO' : (lang == 'es' ? 'AMARILLO' : 'YELLOW');
      case TriageColor.red:
        return lang == 'pt' ? 'VERMELHO' : (lang == 'es' ? 'ROJO' : 'RED');
      case TriageColor.black:
        return lang == 'pt' ? 'ÓBITO' : (lang == 'es' ? 'ÓBITO' : 'BLACK');
    }
  }

  Color color() {
    switch (this) {
      case TriageColor.green: return const Color(0xFF2E7D32);
      case TriageColor.yellow: return const Color(0xFFF2A900);
      case TriageColor.red: return const Color(0xFFD32F2F);
      case TriageColor.black: return Colors.black;
    }
  }

  Color fg() => this == TriageColor.yellow ? Colors.black : Colors.white;
}

class I18n {
  final Locale locale;
  const I18n(this.locale);

  String get lang {
    final l = locale.languageCode.toLowerCase();
    if (l.startsWith('pt')) return 'pt';
    if (l.startsWith('es')) return 'es';
    return 'en';
  }

  String t(String pt, String en, [String? es]) =>
      lang == 'pt' ? pt : (lang == 'es' ? (es ?? pt) : en);

  // UI
  String get appTitle      => t('Método START', 'START Method', 'Método START');
  String get caseTitle     => t('Caso', 'Case', 'Caso');
  String get light         => t('Claro', 'Light', 'Claro');
  String get language      => t('Idioma', 'Language', 'Idioma');
  String get flowchart     => t('Fluxograma START', 'START Flowchart', 'Flujograma START');
  String get openAirway    => t('Liberar vias aéreas', 'Open airway', 'Abrir vía aérea');
  String get applyTourniquet => t('Aplicar torniquete', 'Apply tourniquet', 'Aplicar torniquete');
  String get next          => t('Próxima', 'Next', 'Siguiente');
  String get endNow        => t('Encerrar agora', 'End now', 'Finalizar ahora');
  String get skip          => t('Pular caso', 'Skip case', 'Saltar caso');
  String get result        => t('Resultado', 'Result', 'Resultado');
  String get sendPdf       => t('Enviar PDF por e-mail', 'Send PDF by e-mail', 'Enviar PDF por correo');
  String get exportCsv     => t('Exportar CSV', 'Export CSV', 'Exportar CSV');
  String get exportPdf     => t('Exportar PDF', 'Export PDF', 'Exportar PDF');
  String get backHome      => t('Voltar ao início', 'Back to start', 'Volver al inicio');
  String get correctAnswer => t('Resposta correta', 'Correct answer', 'Respuesta correcta');
  String get yes           => t('SIM', 'YES', 'SÍ');
  String get no            => t('NÃO', 'NO', 'NO');
  String get score         => t('de acerto', 'accuracy', 'de acierto');
  String get airwayOpenedMsg      => t('Vias aéreas liberadas', 'Airway opened', 'Vía aérea abierta');
  String get tourniquetAppliedMsg => t('Torniquete aplicado', 'Tourniquet applied', 'Torniquete aplicado');

  // Labels do caso
  String get ageLabel     => t('Idade', 'Age', 'Edad');
  String get sexLabel     => t('Sexo', 'Sex', 'Sexo');
  String get exsang       => t('Hemorragia exsanguinante', 'Exsanguinating bleeding', 'Hemorragia exanguinante');
  String get walk         => t('Deambula', 'Ambulatory', 'Deambula');
  String get breathInit   => t('Respira (inicial)', 'Breathing (initial)', 'Respira (inicial)');
  String get breathAfter  => t('Respira após abrir VA', 'Breathing after airway', 'Respira tras abrir VA');
  String get obeys        => t('Obedece comandos', 'Obeys commands', 'Obedece órdenes');
  String get injuries     => t('Lesões observadas', 'Observed injuries', 'Lesiones observadas');
  String get pregnant     => t('Gestante', 'Pregnant', 'Gestante');
  String get elderly      => t('Idoso', 'Elderly', 'Anciano');
  // ====== Home (cadastro) & About ======
  String get homeTitle    => t('Método START - Cadastro', 'START Method - Registration', 'Método START - Registro');
  String get homeSubtitle => t('Preencha e inicie a simulação', 'Fill and start the simulation', 'Complete y comience la simulación');

  String get nameLabel   => t('Nome', 'Name', 'Nombre');
  String get sectorLabel => t('Setor/Curso', 'Sector/Course', 'Sector/Curso');
  String get idLabel     => t('RA/ID', 'ID', 'ID');

  String startBtn(int n) => t('Iniciar avaliação ($n casos)', 'Start evaluation ($n cases)', 'Iniciar evaluación ($n casos)');

  String get aboutTitle  => t('Sobre', 'About', 'Acerca de');

  String get aboutText => t(
    'StartRescue é um aplicativo de treinamento e simulação de triagem pelo método START.\n\nConsulte nossa Política de Privacidade no botão abaixo.',
    'StartRescue is a training and simulation app for the START triage method.\n\nView our Privacy Policy using the button below.',
    'StartRescue es una aplicación de entrenamiento y simulación de triaje mediante el método START.\n\nConsulte nuestra Política de Privacidad mediante el botón de abajo.',
  );


  // Comuns
  String get close => t('Fechar', 'Close', 'Cerrar');

  // Mensagens de regra
  String get mustApplyTourniquet => t(
    'Aplique o torniquete antes de classificar a vítima.',
    'Apply the tourniquet before classifying the victim.',
    'Aplique el torniquete antes de clasificar a la víctima.',
  );
  String get tourniquetAppliedNowClassify => t(
    'Torniquete aplicado. Agora classifique a vítima.',
    'Tourniquet applied. Now classify the victim.',
    'Torniquete aplicado. Ahora clasifique a la víctima.',
  );
  String get noExsanguinatingHere => t(
    'Este caso não tem hemorragia exsanguinante.',
    'This case has no exsanguinating bleeding.',
    'Este caso no tiene hemorragia exanguinante.',
  );
  String get tourniquetAlreadyApplied => t(
    'Torniquete já aplicado.',
    'Tourniquet already applied.',
    'Torniquete ya aplicado.',
  );

  String? get emailForSend => null;

  get shareCsvFail => null;

  get sharePdfFail => null;

  /// Traduz o texto de lesões gerado em PT para EN/ES.
  String lesionToLocale(String pt) {
    if (lang == 'pt') return pt;

    final Map<String, Map<String, String>> dict = {
      'Sem lesões aparentes': {
        'en': 'No apparent injuries',
        'es': 'Sin lesiones aparentes',
      },
      'Edema em tornozelo; fratura fechada de rádio': {
        'en': 'Ankle edema; closed radius fracture',
        'es': 'Edema en el tobillo; fractura cerrada del radio',
      },
      'Amputação traumática parcial de antebraço': {
        'en': 'Traumatic partial amputation of forearm',
        'es': 'Amputación traumática parcial del antebrazo',
      },
      'Laceração em couro cabeludo; sangramento moderado': {
        'en': 'Scalp laceration; moderate bleeding',
        'es': 'Laceración del cuero cabelludo; sangrado moderado',
      },
      'Contusão torácica; dor ao respirar': {
        'en': 'Chest contusion; pain on breathing',
        'es': 'Contusión torácica; dolor al respirar',
      },
      'Ferimento perfurante em coxa direita; sangramento controlado': {
        'en': 'Puncture wound on right thigh; bleeding controlled',
        'es': 'Herida punzante en el muslo derecho; sangrado controlado',
      },
      'Luxação de ombro esquerdo; dor intensa': {
        'en': 'Left shoulder dislocation; severe pain',
        'es': 'Luxación de hombro izquierdo; dolor intenso',
      },
      'Queimadura superficial em antebraço; dor local': {
        'en': 'Superficial burn on forearm; local pain',
        'es': 'Quemadura superficial en el antebrazo; dolor local',
      },
    };

    final entry = dict[pt];
    if (entry != null) return entry[lang] ?? pt;

    // Fallback genérico (replaces simples)
    String s = pt;
    if (lang == 'en') {
      s = s.replaceAll('Sem lesões aparentes', 'No apparent injuries');
      s = s.replaceAll('Edema', 'Edema');
      s = s.replaceAll('em tornozelo', 'in ankle');
      s = s.replaceAll('fratura fechada', 'closed fracture');
      s = s.replaceAll('fratura', 'fracture');
      s = s.replaceAll('de rádio', 'of radius');
      s = s.replaceAll('Laceração', 'Laceration');
      s = s.replaceAll('couro cabeludo', 'scalp');
      s = s.replaceAll('Contusão', 'Contusion');
      s = s.replaceAll('tórax', 'chest');
      s = s.replaceAll('dor ao respirar', 'pain on breathing');
      s = s.replaceAll('Amputação traumática parcial', 'Traumatic partial amputation');
      s = s.replaceAll('em antebraço', 'of forearm');
    } else {
      s = s.replaceAll('Sem lesões aparentes', 'Sin lesiones aparentes');
      s = s.replaceAll('Edema', 'Edema');
      s = s.replaceAll('em tornozelo', 'en el tobillo');
      s = s.replaceAll('fratura fechada', 'fractura cerrada');
      s = s.replaceAll('fratura', 'fractura');
      s = s.replaceAll('de rádio', 'del radio');
      s = s.replaceAll('Laceração', 'Laceración');
      s = s.replaceAll('couro cabeludo', 'cuero cabelludo');
      s = s.replaceAll('Contusão', 'Contusión');
      s = s.replaceAll('tórax', 'tórax');
      s = s.replaceAll('dor ao respirar', 'dolor al respirar');
      s = s.replaceAll('Amputação traumática parcial', 'Amputación traumática parcial');
      s = s.replaceAll('em antebraço', 'del antebrazo');
    }
    return s;
  }
}

class CaseData {
  final int idade;
  final Sex sexo;
  final bool hemExs;
  final bool deambula;
  final bool respIni;
  final bool respPos;
  final int fr;
  final double tecSec;
  final bool obedece;
  final String lesao;
  final String gestante; // <-- agora é String
  final bool idoso;

  CaseData({
    required this.idade,
    required this.sexo,
    required this.hemExs,
    required this.deambula,
    required this.respIni,
    required this.respPos,
    required this.fr,
    required this.tecSec,
    required this.obedece,
    required this.lesao,
    required this.gestante,
    required this.idoso,
  });
}
extension SexExt on Sex {
  String get label => this == Sex.male ? 'Masculino' : 'Feminino';
}
class SessionForm {
  final String name;
  final String sector;
  final String id;
  final int total;
  final int timeLimitSec;
  const SessionForm({
    required this.name,
    required this.sector,
    required this.id,
    required this.total,
    this.timeLimitSec = 10,
  });
}

class AnswerRow {
  final int q;
  final TriageColor correta;
  final TriageColor? sua;
  final String explicacao;
  final CaseData data;
  const AnswerRow({
    required this.q,
    required this.correta,
    required this.sua,
    required this.explicacao,
    required this.data,
  });
}
