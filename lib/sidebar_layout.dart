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
    selectedMenu = widget.title;
    currentContent = widget.content;
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
