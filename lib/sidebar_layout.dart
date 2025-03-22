import 'package:flutter/material.dart';
import 'home.dart';
import 'opening_checklist.dart';
import 'closing_checklist.dart';
import 'incident.dart';
import 'create_incident.dart';
import 'temperature.dart';
import 'logout.dart';
import 'team.dart';
import 'report_page.dart';
import 'allergy_check.dart';
import 'setup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'providers/alertsensor_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'providers/checklistalert_data_provider.dart';

class SidebarLayout extends StatefulWidget {
  final Widget content;
  final String token;
  final String title;

  const SidebarLayout({
    Key? key,
    required this.content,
    required this.token,
    required this.title,
  }) : super(key: key);

  @override
  _SidebarLayoutState createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  String selectedMenu = '';
  late Widget currentContent;
  AlertSensorDataProvider? _alertsensorDataProvider;
  ChecklistAlertDataProvider? _checklistalertDataProvider;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Map<String, dynamic>> _getMenuItems(AppLocalizations l10n) {
    return [
      {'icon': Icons.home, 'label': l10n.menuHome},
      {'icon': Icons.check_box, 'label': l10n.menuOpeningChecks},
      {'icon': Icons.check_box_outlined, 'label': l10n.menuClosingChecks},
      {'icon': Icons.thermostat, 'label': l10n.menuTemperatures},
      {'icon': Icons.group, 'label': l10n.menuTeam},
      {'icon': Icons.report, 'label': l10n.menuIncidents},
      {'icon': Icons.bar_chart, 'label': l10n.menuReports},
      {'icon': Icons.health_and_safety, 'label': l10n.menuAllergyCheck},
      {'icon': Icons.settings, 'label': l10n.menuSetup},
    ];
  }

  void _updateContent(String label, Widget page) {
    if (selectedMenu == label) return;

    setState(() {
      selectedMenu = label;
      currentContent = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeProviders();
    selectedMenu = widget.title;
    currentContent = widget.content;
  }

  void _initializeProviders() {
    if (!mounted) return;
    _alertsensorDataProvider =
        Provider.of<AlertSensorDataProvider>(context, listen: false);
    _checklistalertDataProvider =
        Provider.of<ChecklistAlertDataProvider>(context, listen: false);
    _setupTemperatureMonitoring();
  }

  void _setupTemperatureMonitoring() {
    _alertsensorDataProvider?.addListener(() {
      if (!mounted) return;
      print('Sensor data updated');
      final deviceID = _alertsensorDataProvider?.deviceID ?? "";
      _showTemperatureAlert(deviceID);
    });
    _checklistalertDataProvider?.addListener(() {
      if (!mounted) return;
      print('Checklist alert data updated');
      final type = _checklistalertDataProvider?.title ?? "";
      print(type);
      _showChecklistAlert(type);
    });
  }

  void _showChecklistAlert(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final visualAlertsEnabled = prefs.getBool('visualAlerts') ?? true;
    final _audioAlerts = prefs.getBool('audioAlerts') ?? true;
    //if (_audioAlerts) {
    print('Audio alert played successfully');
    await _audioPlayer.setSource(AssetSource('alert.mp3'));
    await _audioPlayer.play(AssetSource('alert.mp3'));
    final opentitle = "OPENING CHECKLIST";
    final closetitle = "CLOSING CHECKLIST";
    String title = "";
    if (type == 'open') {
      title = opentitle;
    } else {
      title = closetitle;
    }
    // }
    // if (visualAlertsEnabled) {
    // Check when the last alert was shown for this device

    // Get alert frequency from preferences (default 240 minutes = 4 hours)

    // Save the current time as the last alert time for this device

    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.red,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12.0),
              const Text(
                'ATTENTION',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            '$title\n\n NOT COMPLETE\n\n\n',
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => fToast.removeCustomToast(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'DISMISS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 5),
    );
    //}
  }

  void _showTemperatureAlert(String deviceId) async {
    // Check visual alerts preference
    final prefs = await SharedPreferences.getInstance();
    final visualAlertsEnabled = prefs.getBool('visualAlerts') ?? true;
    final _audioAlerts = prefs.getBool('audioAlerts') ?? true;
    if (_audioAlerts) {
      print('Audio alert played successfully');
      await _audioPlayer.setSource(AssetSource('alert.mp3'));
      await _audioPlayer.play(AssetSource('alert.mp3'));
    }
    if (visualAlertsEnabled) {
      // Check when the last alert was shown for this device

      // Get alert frequency from preferences (default 240 minutes = 4 hours)

      // Save the current time as the last alert time for this device

      FToast fToast = FToast();
      fToast.init(context);

      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.red,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12.0),
                const Text(
                  'WARNING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '$deviceId\n\n\nOUTSIDE OF SAFE TEMPERATURE THRESHOLD\n\n\n',
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => fToast.removeCustomToast(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
              child: const Text(
                'DISMISS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuItems = _getMenuItems(l10n);

    return Scaffold(
      body: Row(
        children: [
          // Fixed Sidebar
          Container(
            width: 230,
            color: const Color(0xFF2F2E70),
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset('assets/logo.jpeg',
                          height: 100, width: 200),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: menuItems.map((item) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        title: Center(
                          child: selectedMenu != item['label']
                              ? Text(
                                  item['label'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  item['label'],
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        selected: selectedMenu == item['label'],
                        selectedColor: Colors.yellow,
                        selectedTileColor: Colors.yellow,
                        onTap: () {
                          if (item['label'] == l10n.menuHome) {
                            _updateContent(
                                l10n.menuHome, HomeScreen(token: widget.token));
                          } else if (item['label'] == l10n.menuOpeningChecks) {
                            _updateContent(l10n.menuOpeningChecks,
                                OpeningChecklistPage(token: widget.token));
                          } else if (item['label'] == l10n.menuClosingChecks) {
                            _updateContent(l10n.menuClosingChecks,
                                ClosingChecklistPage(token: widget.token));
                          } else if (item['label'] == l10n.menuTemperatures) {
                            _updateContent(
                              l10n.menuTemperatures,
                              TemperatureScreen(token: widget.token),
                            );
                          } else if (item['label'] == l10n.menuTeam) {
                            _updateContent(
                              l10n.menuTeam,
                              TeamScreen(token: widget.token),
                            );
                          } else if (item['label'] == l10n.menuIncidents) {
                            _updateContent(l10n.menuIncidents,
                                IncidentPage(token: widget.token));
                          } else if (item['label'] == l10n.menuReports) {
                            _updateContent(
                              l10n.menuReports,
                              ReportPage(token: widget.token),
                            );
                          } else if (item['label'] == l10n.menuAllergyCheck) {
                            _updateContent(
                              l10n.menuAllergyCheck,
                              AllergyCheckPage(token: widget.token),
                            );
                          } else if (item['label'] == l10n.menuSetup) {
                            _updateContent(
                              l10n.menuSetup,
                              SetupPage(token: widget.token),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Center(
                    child: Text(
                      l10n.menuLogout,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogoutScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Vertical Divider
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          // Content
          Expanded(
            child: currentContent,
          ),
        ],
      ),
    );
  }
}
