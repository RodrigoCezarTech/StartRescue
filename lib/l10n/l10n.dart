import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocDelegate();
  static const supportedLocales = [Locale('pt'), Locale('en')];

  Map<String, String>? _strings;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  Future<bool> load() async {
    final path = 'assets/i18n/${locale.languageCode}.json';
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> map = json.decode(jsonStr);
    _strings = map.map((k, v) => MapEntry(k, v.toString()));
    return true;
  }

  String t(String key) => _strings?[key] ?? key;
}

class _AppLocDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocDelegate();

  @override
  bool isSupported(Locale locale) => ['pt', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final l = AppLocalizations(locale);
    await l.load();
    return l;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
