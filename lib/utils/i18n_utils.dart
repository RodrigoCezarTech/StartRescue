import 'package:flutter/widgets.dart';

String currentLang(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

String translateLesionText(String pt, String lang) {
  if (lang != 'en') return pt;

  // mapeamento mínimo dos textos que o gerador usa hoje
  if (pt.startsWith('Sem lesões aparentes')) {
    return 'No apparent injuries';
  }
  if (pt.startsWith('Edema em tornozelo')) {
    return 'Ankle edema; closed radius fracture';
  }
  // fallback (se aparecer outra frase em PT por engano)
  return pt;
}
