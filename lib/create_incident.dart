import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alpha/config.dart';
import 'home.dart';

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

    if (incident.isEmpty || employeeName.isEmpty || resolution.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final url =
        '${Config.baseUrl}/user/incidents'; // Replace with your backend IP

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
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incident Created Successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(token: widget.token),
          ),
        );
      } else {
        print('Failed to create incident: ${response.body}');
      }
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
