
import 'dart:math';
import 'models.dart';

List<CaseData> generateCases() {
  final rand = Random();
  final out = <CaseData>[];

  const lesoes = <String>[
    'Sem lesões aparentes',
    'Edema em tornozelo; fratura fechada de rádio',
    'Amputação traumática parcial de antebraço',
    'Laceração em couro cabeludo; sangramento moderado',
    'Contusão torácica; dor ao respirar',
    'Ferimento perfurante em coxa direita; sangramento controlado',
    'Luxação de ombro esquerdo; dor intensa',
    'Queimadura superficial em antebraço; dor local',
  ];

  int gestantesCriadas = 0;
  int idososCriados = 0;

  for (int i = 0; i < 20; i++) {
    final sexo = rand.nextBool() ? Sex.male : Sex.female;

    int idade = 18 + rand.nextInt(68);
    if (idade >= 60 && idososCriados >= 5) {
      idade = 18 + rand.nextInt(42);
    }

    final idoso = idade >= 60;
    if (idoso) idososCriados++;

    String gestante = 'NÃO';
    if (sexo == Sex.female &&
        idade >= 18 &&
        idade <= 45 &&
        gestantesCriadas < 3 &&
        rand.nextInt(10) < 4) {
      gestante = 'SIM';
      gestantesCriadas++;
    }

    // Distribuição de perfis para exercitar diferentes decisões START.
    final perfil = i % 5;

    bool deambula = perfil == 0;
    bool respIni = perfil != 1 && perfil != 2;
    bool respPos = respIni || perfil == 2;

    // Pequena variação adicional dos casos respiratórios.
    if (perfil == 3 || perfil == 4) {
      respIni = true;
      respPos = true;
    }

    int fr;
    double tec;
    bool obedece;

    if (deambula) {
      fr = 14 + rand.nextInt(15);
      tec = 1.0 + rand.nextInt(9) / 10;
      obedece = true;
    } else if (!respPos) {
      fr = 0;
      tec = double.infinity;
      obedece = false;
    } else if (!respIni) {
      fr = 8 + rand.nextInt(28);
      tec = 1.0 + rand.nextInt(30) / 10;
      obedece = false;
    } else {
      fr = rand.nextInt(4) == 0
          ? 31 + rand.nextInt(10)
          : 10 + rand.nextInt(21);
      tec = rand.nextBool()
          ? 1.0 + rand.nextInt(10) / 10
          : 2.1 + rand.nextInt(20) / 10;
      obedece = rand.nextBool();
    }

    final hemExs = !deambula && rand.nextInt(7) == 0;

    final lesao = hemExs
        ? 'Amputação traumática parcial de antebraço'
        : lesoes[rand.nextInt(lesoes.length)];
    out.add(CaseData(
      idade: idade,
      sexo: sexo,
      hemExs: hemExs,
      deambula: deambula,
      respIni: respIni,
      respPos: respPos,
      fr: fr,
      tecSec: tec,
      obedece: obedece,
      lesao: lesao,
      gestante: gestante,
      idoso: idoso,
    ));
  }

  out.shuffle(rand);
  return out;
}
