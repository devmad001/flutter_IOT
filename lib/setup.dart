import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/language_selector.dart';

class SetupPage extends StatefulWidget {
  final String token;

  const SetupPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.setup,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(l10n.notifications),
              subtitle: Text(l10n.notificationsSubtitle),
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 16),
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LanguageSelector(),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.security),
              title: Text(l10n.security),
              subtitle: Text(l10n.securitySubtitle),
              onTap: () {
                // TODO: Implement security settings
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup),
              title: Text(l10n.backup),
              subtitle: Text(l10n.backupSubtitle),
              onTap: () {
                // TODO: Implement backup settings
              },
            ),
          ),
        ],
      ),
    );
  }
}
