import 'package:flutter/material.dart';
import '../triage/models.dart';
import '../triage/triage_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onToggleTheme,
    this.onChangeLocale,
  });

  final VoidCallback? onToggleTheme;
  final ValueChanged<Locale>? onChangeLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameCtrl   = TextEditingController(text: 'Aluno(a)');
  final _sectorCtrl = TextEditingController(text: 'Turma A');
  final _idCtrl     = TextEditingController(text: '0001');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDefaultTexts(Localizations.localeOf(context));
  }
  String _lastLanguage = 'pt';

  void _updateDefaultTexts(Locale locale) {
    final newLanguage = locale.languageCode;

    if (newLanguage == _lastLanguage) return;

    const defaultNames = {
      'pt': 'Aluno(a)',
      'en': 'Student',
      'es': 'Alumno(a)',
    };

    const defaultSectors = {
      'pt': 'Turma A',
      'en': 'Class A',
      'es': 'Clase A',
    };

    final oldName = defaultNames[_lastLanguage];
    final oldSector = defaultSectors[_lastLanguage];

    if (_nameCtrl.text == oldName) {
      _nameCtrl.text = defaultNames[newLanguage] ?? 'Student';
    }

    if (_sectorCtrl.text == oldSector) {
      _sectorCtrl.text = defaultSectors[newLanguage] ?? 'Class A';
    }

    _lastLanguage = newLanguage;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sectorCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  void _showFlowchart() {
    final i18n = I18n(Localizations.localeOf(context));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(i18n.flowchart),
        content: Image.asset(
          'assets/images/flowchart.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('${i18n.flowchart}: ${i18n.t('arquivo não encontrado', 'file not found', 'archivo no encontrado')}'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(i18n.close)),
        ],
      ),
    );
  }


  void _showAbout() {
    final i18n = I18n(Localizations.localeOf(context));

    final privacyUrl = i18n.lang == 'pt'
        ? 'https://rodrigocezartech.github.io/startrescue-privacy/politica.html'
        : 'https://rodrigocezartech.github.io/startrescue-privacy/privacy.html';

    showAboutDialog(
      context: context,
      applicationName: i18n.appTitle,
      applicationVersion: '1.0.0',
      children: [
        Text(i18n.aboutText),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () async {
            await launchUrl(
              Uri.parse(privacyUrl),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Text(
            i18n.t(
              'Política de Privacidade',
              'Privacy Policy',
              'Política de Privacidad',
            ),
          ),
        ),
      ],
    );
  }


  void _changeLanguage() {
    showMenu<Locale>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 12, 0),
      items: const [
        PopupMenuItem(value: Locale('pt'), child: Text('Português')),
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('es'), child: Text('Español')),
      ],
    ).then((loc) {
      if (loc == null) return;
      widget.onChangeLocale?.call(loc);
      setState(() {}); // refaz textos
    });
  }

  void _start() {
    final form = SessionForm(
      name: _nameCtrl.text.trim(),
      sector: _sectorCtrl.text.trim(),
      id: _idCtrl.text.trim(),
      total: 20,
      timeLimitSec: 10,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TriageScreen(
          form: form,
          onToggleTheme: widget.onToggleTheme ?? () {},
          onChangeLocale: widget.onChangeLocale ?? (_) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n(Localizations.localeOf(context));
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.homeTitle),
        actions: [
          IconButton(
            tooltip: i18n.flowchart,
            onPressed: _showFlowchart,
            icon: const Icon(Icons.account_tree_outlined),
          ),
          PopupMenuButton<Locale>(
            tooltip: i18n.language,
            icon: const Icon(Icons.language),
            onSelected: (loc) {
              _updateDefaultTexts(loc);
              widget.onChangeLocale?.call(loc);
              setState(() {});
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('pt'), child: Text('Português')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
              PopupMenuItem(value: Locale('es'), child: Text('Español')),
            ],
          ),
          IconButton(
            tooltip: i18n.light,
            onPressed: widget.onToggleTheme ?? () {},
            icon: const Icon(Icons.brightness_6_outlined),
          ),
          IconButton(
            tooltip: i18n.aboutTitle,
            onPressed: _showAbout,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(i18n.homeSubtitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: i18n.nameLabel),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sectorCtrl,
              decoration: InputDecoration(labelText: i18n.sectorLabel),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(labelText: i18n.idLabel),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _start,
                child: Text(i18n.startBtn(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
