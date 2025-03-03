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

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home, 'label': 'HOME'},
    {'icon': Icons.check_box, 'label': 'OPENING CHECKS'},
    {'icon': Icons.check_box_outlined, 'label': 'CLOSING CHECKS'},
    {'icon': Icons.thermostat, 'label': 'TEMPERATURES'},
    {'icon': Icons.group, 'label': 'TEAM'},
    {'icon': Icons.report, 'label': 'INCIDENTS'},
    {'icon': Icons.bar_chart, 'label': 'REPORTS'},
    {'icon': Icons.health_and_safety, 'label': 'ALLERGY CHECK'},
    {'icon': Icons.settings, 'label': 'SETUP'},
  ];

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
                children: _menuItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.blue[900]),
                    title: Text(item['label']),
                    selected: selectedMenu == item['label'],
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      // Close the drawer before navigating.
                      Navigator.pop(context);

                      if (item['label'] == 'HOME') {
                        _navigateTo('HOME', const SizedBox(), isHome: true);
                      } else if (item['label'] == 'OPENING CHECKS') {
                        _navigateTo('OPENING CHECKS',
                            OpeningChecklistPage(token: widget.token));
                      } else if (item['label'] == 'CLOSING CHECKS') {
                        _navigateTo('CLOSING CHECKS',
                            ClosingChecklistPage(token: widget.token));
                      } else if (item['label'] == 'TEMPERATURES') {
                        _navigateTo(
                          'TEMPERATURES',
                          TemperatureScreen(token: widget.token),
                        );
                      } else if (item['label'] == 'TEAM') {
                        _navigateTo(
                          'TEAM',
                          TeamScreen(token: widget.token),
                        );
                      } else if (item['label'] == 'INCIDENTS') {
                        _navigateTo('INCIDENTS',
                            CreateIncidentPage(token: widget.token));
                      } else if (item['label'] == 'REPORTS') {
                        _navigateTo(
                          'REPORTS',
                          ReportPage(token: widget.token),
                        );
                      } else if (item['label'] == 'ALLERGY CHECK') {
                        _navigateTo(
                          'ALLERGY CHECK',
                          AllergyCheckPage(token: widget.token),
                        );
                      }
                      // Add more cases if needed.
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.red[700]),
                title: Text('LOGOUT', style: TextStyle(color: Colors.red[700])),
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
