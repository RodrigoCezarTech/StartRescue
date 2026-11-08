import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _build = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((pi) {
      if (!mounted) return;
      setState(() {
        _version = pi.version;
        _build = pi.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPt = Localizations.localeOf(context).languageCode == 'pt';
    final privacyUrl = isPt
        ? Uri.parse(
      'https://rodrigocezartech.github.io/startrescue-privacy/politica.html',
    )
        : Uri.parse(
      'https://rodrigocezartech.github.io/startrescue-privacy/privacy.html',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isPt ? 'Sobre' : 'About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isPt ? 'Método START' : 'START Method',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(isPt ? 'Versão: $_version ($_build)' : 'Version: $_version ($_build)'),
            const SizedBox(height: 16),
            Text(
              isPt
                  ? 'Aplicativo para treino de triagem START.'
                  : 'App for START triage training.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (await canLaunchUrl(privacyUrl)) {
                  await launchUrl(privacyUrl, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(isPt ? 'Política de privacidade' : 'Privacy policy'),
            ),
          ],
        ),
      ),
    );
  }
}
