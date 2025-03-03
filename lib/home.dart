import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'opening_checklist.dart';
import 'closing_checklist.dart';
import 'create_incident.dart';
import 'sidebar_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'socket_service.dart';

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
    // Initialize socket connection
    SocketService.instance.initSocket(widget.token);
    // Subscribe to sensor updates
    SocketService.instance
        .subscribeToEvent('newSensorData', _handleSensorUpdate);

    // Fetch both checklist and sensor data
    fetchChecklistStatus();
    fetchSensorData();
  }

  @override
  void dispose() {
    // Clean up socket connection
    SocketService.instance.disconnect();
    super.dispose();
  }

  void _handleSensorUpdate(dynamic data) {
    print('Sensor update received: $data');
    if (data != null) {
      setState(() {
        // Update the sensor data with the new reading
        final index = sensorData
            .indexWhere((sensor) => sensor['device_id'] == data['device_id']);
        if (index != -1) {
          // Update existing sensor data
          sensorData[index] = {
            ...sensorData[index],
            'temperature': data['temperature']?.toString() ?? '--',
            'battery': data['battery']?.toString() ?? '--',
            'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          };
        } else {
          // Add new sensor data
          sensorData.add({
            'device_id': data['device_id'],
            'restaurantName': data['restaurantName'] ?? 'Unknown Restaurant',
            'temperature': data['temperature']?.toString() ?? '--',
            'battery': data['battery']?.toString() ?? '--',
            'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          });
        }
      });
    }
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
      MaterialPageRoute(
          builder: (context) => CreateIncidentPage(token: widget.token)),
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
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      final url = '$baseUrl/user/temperatureSetting';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> sensorRecords = data['data'];

        // Initialize sensor data with basic information from API
        setState(() {
          sensorData = sensorRecords
              .map((record) => {
                    'device_id': record['sensor_id'],
                    'restaurantName':
                        record['restaurant_id']['name'] ?? 'Unknown Restaurant',
                    'temperature': '--', // Will be updated by socket
                    'battery': '--', // Will be updated by socket
                    'timestamp': DateTime.now()
                        .toIso8601String(), // Will be updated by socket
                    'min_temp': record['min_temp'] ?? 0,
                    'max_temp': record['max_temp'] ?? 5,
                  })
              .toList();
          isSensorLoading = false;
        });
      } else {
        setState(() {
          sensorErrorMessage =
              'Error fetching sensor data: ${response.statusCode}';
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
        child: Text(sensorErrorMessage!,
            style: const TextStyle(color: Colors.red)),
      );
    }

    if (sensorData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text('No sensor data available.'),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: sensorData.map((sensor) {
        final deviceId = sensor['device_id'] ?? 'Unknown';
        final restaurantName = sensor['restaurantName'] ?? 'Unknown Restaurant';
        final temperature = sensor['temperature']?.toString() ?? '--';
        final battery = sensor['battery']?.toString() ?? '--';
        final timestamp = sensor['timestamp'] ?? '--';
        final minTemp = sensor['min_temp'] ?? 0;
        final maxTemp = sensor['max_temp'] ?? 5;
        print(minTemp);
        print(maxTemp);
        return Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Temperature:'),
                  Text(
                    '$temperature°C',
                    style: TextStyle(
                      color: _getTemperatureColor(
                        double.tryParse(temperature) ?? 0,
                        minTemp,
                        maxTemp,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Battery:'),
                  Text(
                    '$battery%',
                    style: TextStyle(
                      color: (double.tryParse(battery) ?? 0) > 20
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Last Updated: ${DateTime.parse(timestamp).toLocal().toString().split('.')[0]}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getTemperatureColor(
      double temperature, double minTemp, double maxTemp) {
    if (temperature < minTemp || temperature > maxTemp) {
      return Colors.red;
    }
    return Colors.green;
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
                  _buildChecklistItem(
                      'OPENING CHECKS', openingChecklistCompleted, 'opening'),
                  _buildChecklistItem(
                      'CLOSING CHECKS', closingChecklistCompleted, 'closing'),
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
