import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamScreen extends StatefulWidget {
  final String token;

  const TeamScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool _isLoading = false;
  String? _error;

  // Mock data - replace with actual API calls
  List<Map<String, dynamic>> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/user/members'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _teamMembers = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _error = l10n.failedToLoadTeamMembers(response.statusCode.toString());
          _isLoading = false;
        });
        print('Failed to load team members: ${response.body}');
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.errorFetchingTeamMembers(e.toString());
        _isLoading = false;
      });
      print('Error fetching team members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Card(
        margin: const EdgeInsets.only(
            top: 46.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.teamMembersList,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchTeamMembers,
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        )
                      : DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: [
                            DataColumn2(
                              label: Text(l10n.name),
                              size: ColumnSize.S,
                            ),
                            DataColumn2(
                              label: Text(l10n.userLevel),
                              size: ColumnSize.S,
                            ),
                            DataColumn2(
                              label: Text(l10n.emailAddress),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(
                              label: Text(l10n.trainingLevel),
                              size: ColumnSize.S,
                            ),
                          ],
                          rows: _teamMembers.map((member) {
                            return DataRow2(
                              cells: [
                                DataCell(Text(member['name'] ?? '')),
                                DataCell(Text(member['userLevel'] ?? '')),
                                DataCell(Text(member['email'] ?? '')),
                                DataCell(Text(member['trainingLevel'] ?? '')),
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
