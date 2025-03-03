import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alpha/config.dart';

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
        setState(() {
          _error = 'Failed to load team members: ${response.statusCode}';
          _isLoading = false;
        });
        print('Failed to load team members: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching team members: $e';
        _isLoading = false;
      });
      print('Error fetching team members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'TEAM MEMBERS LIST',
                style: TextStyle(
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
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : DataTable2(
                          columns: const [
                            DataColumn2(label: Text('NAME')),
                            DataColumn2(label: Text('USER LEVEL')),
                            DataColumn2(label: Text('EMAIL ADDRESS')),
                            DataColumn2(label: Text('TRAINING LEVEL')),
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
