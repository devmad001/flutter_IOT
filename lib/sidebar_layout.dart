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

  void _navigateTo(String label, Widget page, {bool isHome = false}) {
    if (selectedMenu == label) return;

    setState(() {
      selectedMenu = label;
    });

    if (isHome) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: widget.token),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SidebarLayout(
            token: widget.token,
            content: page,
            title: label,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    selectedMenu = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuItems = _getMenuItems(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.jpeg',
                    height: 80,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: menuItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.blue[900]),
                    title: Text(item['label']),
                    selected: selectedMenu == item['label'],
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      // Close the drawer before navigating.
                      Navigator.pop(context);

                      if (item['label'] == l10n.menuHome) {
                        _navigateTo(l10n.menuHome, const SizedBox(),
                            isHome: true);
                      } else if (item['label'] == l10n.menuOpeningChecks) {
                        _navigateTo(l10n.menuOpeningChecks,
                            OpeningChecklistPage(token: widget.token));
                      } else if (item['label'] == l10n.menuClosingChecks) {
                        _navigateTo(l10n.menuClosingChecks,
                            ClosingChecklistPage(token: widget.token));
                      } else if (item['label'] == l10n.menuTemperatures) {
                        _navigateTo(
                          l10n.menuTemperatures,
                          TemperatureScreen(token: widget.token),
                        );
                      } else if (item['label'] == l10n.menuTeam) {
                        _navigateTo(
                          l10n.menuTeam,
                          TeamScreen(token: widget.token),
                        );
                      } else if (item['label'] == l10n.menuIncidents) {
                        _navigateTo(l10n.menuIncidents,
                            CreateIncidentPage(token: widget.token));
                      } else if (item['label'] == l10n.menuReports) {
                        _navigateTo(
                          l10n.menuReports,
                          ReportPage(token: widget.token),
                        );
                      } else if (item['label'] == l10n.menuAllergyCheck) {
                        _navigateTo(
                          l10n.menuAllergyCheck,
                          AllergyCheckPage(token: widget.token),
                        );
                      } else if (item['label'] == l10n.menuSetup) {
                        _navigateTo(
                          l10n.menuSetup,
                          SetupPage(token: widget.token),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.red[700]),
                title: Text(l10n.menuLogout,
                    style: TextStyle(color: Colors.red[700])),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogoutScreen()),
                  );
                }),
          ],
        ),
      ),
      body: widget.content,
    );
  }
}
