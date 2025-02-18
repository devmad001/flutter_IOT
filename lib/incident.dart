import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For formatting date & time
import 'create_incident.dart'; // Import the form page
import 'package:alpha/config.dart';

class IncidentPage extends StatefulWidget {
  final String token;

  const IncidentPage({Key? key, required this.token}) : super(key: key);

  @override
  _IncidentPageState createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  List<dynamic> incidents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIncidents();
  }

  Future<void> fetchIncidents() async {
    final url = '${Config.baseUrl}/user/incidents';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Sort incidents so that the newest ones are on top
        data['incidents'].sort((a, b) {
          DateTime dateA = DateTime.parse(a['reportedAt']);
          DateTime dateB = DateTime.parse(b['reportedAt']);
          return dateB.compareTo(dateA); // Newest first
        });

        setState(() {
          incidents = data['incidents'];
          isLoading = false;
        });
      } else {
        print('Failed to load incidents: ${response.body}');
      }
    } catch (e) {
      print('Error fetching incidents: $e');
    }
  }

  Future<void> updateIncidentStatus(String incidentId, bool isResolved) async {
    if (isResolved) {
      String? resolution = await _askForResolution();
      if (resolution == null || resolution.isEmpty) return;

      final url = '${Config.baseUrl}/user/incidents/$incidentId';
      final body = jsonEncode({'status': 'Resolved', 'resolution': resolution});

      try {
        final response = await http.patch(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${widget.token}',
            'Content-Type': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          fetchIncidents();
        } else {
          print('Failed to update incident: ${response.body}');
        }
      } catch (e) {
        print('Error updating incident: $e');
      }
    }
  }

  Future<void> deleteIncident(String incidentId) async {
    bool? confirmDelete = await _confirmDelete();
    if (confirmDelete != true) return;

    final url = '${Config.baseUrl}/user/incidents/$incidentId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          incidents.removeWhere((incident) => incident['_id'] == incidentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incident deleted successfully")),
        );
      } else {
        print('Failed to delete incident: ${response.body}');
      }
    } catch (e) {
      print('Error deleting incident: $e');
    }
  }

  Future<String?> _askForResolution() async {
    TextEditingController resolutionController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Resolution'),
          content: TextField(
            controller: resolutionController,
            decoration: const InputDecoration(labelText: 'Resolution Details'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, resolutionController.text.trim());
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this incident? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCreateIncident() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateIncidentPage(token: widget.token),
      ),
    ).then((_) => fetchIncidents());
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime); // Format date & time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incidents')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: _navigateToCreateIncident,
                  child: const Text('Create Incident'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: incidents.length,
                    itemBuilder: (context, index) {
                      final incident = incidents[index];
                      String formattedDate = formatDateTime(incident['reportedAt']);
                      bool isResolved = incident['status'] == 'Resolved';

                      return Card(
                        margin: const EdgeInsets.all(8),
                        color: isResolved ? Colors.green[100] : Colors.red[100], // Green for resolved, Red for unresolved
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                incident['incident'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isResolved ? Colors.green[800] : Colors.red[800],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Employee: ${incident['employeeName']}"),
                              if (isResolved)
                                Text(
                                  "Resolution: ${incident['resolution'] ?? 'N/A'}",
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isResolved,
                                        onChanged: (value) {
                                          if (value != null) {
                                            updateIncidentStatus(incident['_id'], value);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => deleteIncident(incident['_id']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
