import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/language_selector.dart';
import 'widgets/metrics_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _visualAlerts = true;
  bool _audioAlerts = true;

  @override
  void initState() {
    super.initState();
    _loadAlertPreferences();
  }

  Future<void> _loadAlertPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _visualAlerts = prefs.getBool('visualAlerts') ?? true;
      _audioAlerts = prefs.getBool('audioAlerts') ?? true;
    });
  }

  Future<void> _saveAlertPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visualAlerts', _visualAlerts);
    await prefs.setBool('audioAlerts', _audioAlerts);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(
          top: 46.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LanguageSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thermostat),
                      const SizedBox(width: 16),
                      Text(
                        l10n.temperatureUnit,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const MetricsSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications),
                      const SizedBox(width: 16),
                      Text(
                        l10n.alertSettings,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.visualAlerts),
                    subtitle: Text(l10n.showPopupNotifications),
                    value: _visualAlerts,
                    onChanged: (bool value) {
                      setState(() {
                        _visualAlerts = value;
                        _saveAlertPreferences();
                      });
                    },
                    secondary: const Icon(Icons.visibility),
                  ),
                  SwitchListTile(
                    title: Text(l10n.audioAlerts),
                    subtitle: Text(l10n.playSoundNotifications),
                    value: _audioAlerts,
                    onChanged: (bool value) {
                      setState(() {
                        _audioAlerts = value;
                        _saveAlertPreferences();
                      });
                    },
                    secondary: const Icon(Icons.volume_up),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
