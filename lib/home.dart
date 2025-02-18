import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'opening_checklist.dart';
import 'closing_checklist.dart';
import 'create_incident.dart';
import 'sidebar_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL'];

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Checklist state
  bool isLoading = true;
  bool openingChecklistCompleted = false;
  bool closingChecklistCompleted = false;

  // Sensor state
  bool isSensorLoading = true;
  String? sensorErrorMessage;
  List<Map<String, dynamic>> sensorData = [];

  @override
  void initState() {
    super.initState();
    // Fetch both checklist and sensor data
    fetchChecklistStatus();
    fetchSensorData();
  }

  // ---------------------------
  // CHECKLIST FUNCTIONALITY
  // ---------------------------
  Future<void> fetchChecklistStatus() async {
    try {
      openingChecklistCompleted = await _checkAllTasksCompleted('opening');
      closingChecklistCompleted = await _checkAllTasksCompleted('closing');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching checklist status: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _checkAllTasksCompleted(String type) async {
    final url = '$baseUrl/user/checklist/$type';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> tasks = data['tasks'];
        return tasks.every((task) => task['status'] == 'completed');
      }
    } catch (e) {
      print('Error fetching $type checklist: $e');
    }
    return false;
  }

  void _navigateTo(String section) {
    Widget page;
    if (section == 'opening') {
      page = OpeningChecklistPage(token: widget.token);
    } else {
      page = ClosingChecklistPage(token: widget.token);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) => fetchChecklistStatus());
  }

  void _navigateToCreateIncident() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateIncidentPage(token: widget.token)),
    );
  }

  Widget _buildChecklistItem(String title, bool isCompleted, String section) {
    return GestureDetector(
      onTap: () => _navigateTo(section),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                isCompleted ? 'VIEW CHECKLIST' : 'CLICK TO FILL',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentButton() {
    return GestureDetector(
      onTap: _navigateToCreateIncident,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ADD INCIDENT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'CREATE INCIDENT',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // SENSOR FUNCTIONALITY (Latest Data Only)
  // ---------------------------
  Future<void> fetchSensorData() async {
    try {
      final url = '$baseUrl/user/sensor';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> sensorRecords = data['data'];

        // Group sensor records by device_id to keep only the latest reading
        Map<String, Map<String, dynamic>> sensorMap = {};
        for (var record in sensorRecords) {
          String deviceId = record['device_id'];
          DateTime recordTime = DateTime.parse(record['createdAt']);
          if (!sensorMap.containsKey(deviceId) ||
              recordTime.isAfter(DateTime.parse(sensorMap[deviceId]!['createdAt']))) {
            sensorMap[deviceId] = Map<String, dynamic>.from(record);
          }
        }

        setState(() {
          sensorData = sensorMap.values.toList();
          isSensorLoading = false;
        });
      } else {
        setState(() {
          sensorErrorMessage = 'Error fetching sensor data: ${response.statusCode}';
          isSensorLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      setState(() {
        sensorErrorMessage = 'An error occurred while fetching sensor data: $e';
        isSensorLoading = false;
      });
    }
  }

  Widget _buildSensorBoxes() {
    if (sensorErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(sensorErrorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (sensorData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text('No sensor data available.'),
      );
    }

    // Build a wrap of boxes for each sensor (latest reading) with friendly names.
    List<Widget> boxes = [];
    for (int i = 0; i < sensorData.length; i++) {
      final sensor = sensorData[i];
      // Use sensor's name if available; otherwise, assign "Fridge 1", "Fridge 2", etc.
      final friendlyName = sensor['name'] ?? 'Fridge ${i + 1}';
      final temperature = sensor['uplink_message']?['decoded_payload']?['temperature']?.toString() ?? '--';

      boxes.add(
        Container(
          width: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                friendlyName.toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '$temperature°C',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: boxes,
    );
  }

  // ---------------------------
  // BUILD METHOD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    // If either checklist or sensor data is still loading, show a loader.
    final isAnyLoading = isLoading || isSensorLoading;

    return SidebarLayout(
      token: widget.token,
      title: 'HOME',
      content: isAnyLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Checklist items
                  _buildChecklistItem('OPENING CHECKS', openingChecklistCompleted, 'opening'),
                  _buildChecklistItem('CLOSING CHECKS', closingChecklistCompleted, 'closing'),
                  // Incident button
                  _buildIncidentButton(),
                  const SizedBox(height: 20),
                  // Sensor boxes showing latest sensor data with friendly names
                  _buildSensorBoxes(),
                ],
              ),
            ),
    );
  }
}
