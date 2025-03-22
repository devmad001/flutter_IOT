import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'home.dart';
import 'incident.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:provider/provider.dart';
import 'package:guardstar/providers/language_provider.dart';

class CreateIncidentPage extends StatefulWidget {
  final String token;

  const CreateIncidentPage({Key? key, required this.token}) : super(key: key);

  @override
  _CreateIncidentPageState createState() => _CreateIncidentPageState();
}

class _CreateIncidentPageState extends State<CreateIncidentPage> {
  final _incidentController = TextEditingController();
  final _employeeNameController = TextEditingController();
  final _resolutionController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitIncident() async {
    final incident = _incidentController.text.trim();
    final employeeName = _employeeNameController.text.trim();
    final resolution = _resolutionController.text.trim();

    // Get the current selected language from the provider
    final language = Provider.of<LanguageProvider>(context, listen: false)
        .currentLocale
        .languageCode;

    setState(() {
      _isSubmitting = true;
    });
    print('Language: $language');
    String displayLanguage;
    if (language == 'en') {
      displayLanguage = 'English';
    } else if (language == 'pl') {
      displayLanguage = 'Polish';
    } else if (language == 'zh') {
      displayLanguage = 'Chinese';
    } else if (language == 'tr') {
      displayLanguage = 'Turkish';
    } else if (language == 'it') {
      displayLanguage = 'Italian';
    } else if (language == 'ja') {
      displayLanguage = 'Japanese';
    } else if (language == 'hi') {
      displayLanguage = 'Hindi';
    } else if (language == 'ar') {
      displayLanguage = 'Arabic';
    } else {
      displayLanguage = language;
    }
    String status = 'Open';

    if (resolution != '') {
      status = 'Resolved';
    }

    final url = '${Config.baseUrl}/user/incidents?lng=$displayLanguage';
    print('URL: $url');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'incident': incident,
          'employeeName': employeeName,
          'resolution': resolution,
          'status': status,
        }),
      );
      print('Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incident Created Successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error creating incident: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Incident')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _incidentController,
              decoration: const InputDecoration(labelText: 'Incident'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _resolutionController,
              decoration: const InputDecoration(labelText: 'Resolution'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _employeeNameController,
              decoration: const InputDecoration(labelText: 'Employee Name'),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitIncident,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
