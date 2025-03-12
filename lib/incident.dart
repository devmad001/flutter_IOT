import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For formatting date & time
import 'create_incident.dart'; // Import the form page
import 'package:guardstar/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guardstar/sidebar_layout.dart';

class IncidentPage extends StatefulWidget {
  final String token;

  const IncidentPage({Key? key, required this.token}) : super(key: key);

  @override
  _IncidentPageState createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  List<dynamic> incidents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchIncidents();
  }

  Future<void> fetchIncidents() async {
    setState(() {
      isLoading = true;
    });

    final url = '${Config.baseUrl}/user/incidents';
    print('Fetching incidents from: $url');
    print(
        'Using token: ${widget.token.substring(0, 10)}...'); // Only print first 10 chars for security

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null) {
          print('Received null data from API');
          setState(() {
            incidents = [];
            isLoading = false;
          });
          return;
        }

        List<dynamic> incidentsList;

        // Handle both array and object response formats

        incidentsList = data;

        // Sort incidents so that the newest ones are on top
        incidentsList.sort((a, b) {
          // Handle null reportedAt values
          if (a['reportedAt'] == null) return 1; // Move null dates to the end
          if (b['reportedAt'] == null) return -1; // Move null dates to the end

          DateTime dateA = DateTime.parse(a['reportedAt']);
          DateTime dateB = DateTime.parse(b['reportedAt']);
          return dateB.compareTo(dateA); // Newest first
        });

        setState(() {
          incidents = incidentsList;
          isLoading = false;
        });
      } else {
        print('Failed to load incidents: ${response.body}');
        setState(() {
          incidents = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to load incidents: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching incidents: $e');
      setState(() {
        incidents = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading incidents: $e')),
      );
    }
  }

  Future<void> updateIncidentStatus(String incidentId, bool isResolved) async {
    if (isResolved) {
      String? resolution = await _askForResolution();
      if (resolution == null || resolution.isEmpty) return;

      final url = '${Config.baseUrl}/user/incidents/$incidentId';
      final body = jsonEncode({'status': 'Resolved', 'resolution': resolution});
      setState(() {
        isLoading = true;
      });
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
          setState(() {
            isLoading = false;
          });
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
          content: const Text(
              'Are you sure you want to delete this incident? This action cannot be undone.'),
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
        builder: (context) => SidebarLayout(
            token: widget.token,
            content: CreateIncidentPage(token: widget.token),
            title:""
          ), 
      ),
    ).then((_) => fetchIncidents());
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('yyyy-MM-dd hh:mm a')
        .format(dateTime); // Format date & time
  }

  String _getMappedLanguageCode(String languageCode) {
    // Map language codes
    switch (languageCode) {
      case 'zh':
        return 'ch';
      case 'en':
        return 'en';
      case 'pl':
        return 'po';
      case 'it':
        return 'it';
      case 'tr':
        return 'tu';
      default:
        return languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0, left: 16.0, right: 16.0, bottom: 16.0),
                  child: Text(
                    l10n.incidents,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToCreateIncident,
                  child: Text(l10n.createIncident),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: incidents.length,
                    itemBuilder: (context, index) {
                      final incident = incidents[index];
                      String formattedDate = incident['reportedAt'] != null
                          ? formatDateTime(incident['reportedAt'])
                          : 'No date reported';
                      bool isResolved = incident['status'] == 'Resolved';

                      // Get the localized incident text based on current language
                      String mappedLanguageCode = _getMappedLanguageCode(
                          Localizations.localeOf(context).languageCode);
                      String incidentText =
                          incident['incident_$mappedLanguageCode'] ??
                              incident['incident_en'];
                      String resolutionText =
                          incident['resolution_$mappedLanguageCode'] ??
                              incident['resolution_en'];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        color: isResolved ? Colors.green[100] : Colors.red[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                incidentText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isResolved
                                      ? Colors.green[800]
                                      : Colors.red[800],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("${l10n.team}: ${incident['employeeName']}"),
                              if (isResolved)
                                Text(
                                  "${l10n.info}: $resolutionText",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isResolved,
                                        onChanged: (value) {
                                          if (value != null) {
                                            updateIncidentStatus(
                                                incident['_id'], value);
                                          }
                                        },
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
