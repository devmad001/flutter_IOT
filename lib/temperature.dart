import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'config.dart';

class TemperatureScreen extends StatefulWidget {
  final String token;

  const TemperatureScreen({Key? key, required this.token}) : super(key: key);

  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  // --- Sensor Data State ---
  bool sensorLoading = true;
  String? sensorError;
  Map<String, dynamic> latestSensorData = {};

  // --- Temperature Settings State ---
  bool settingsLoading = true;
  bool settingsSubmitting = false;
  String? settingsError;
  double minTempSetting = 5;
  double maxTempSetting = 10;
  bool alertEnabled = false;
  int delayBeforeAlert = 0;
  String? settingId; // Will be non-null if a setting exists
  final TextEditingController _delayController = TextEditingController();
  final _settingsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    fetchTemperatureSetting();
  }

  // --- Sensor Data Functions ---
  Future<void> fetchSensorData() async {
    setState(() {
      sensorLoading = true;
      sensorError = null;
    });
    final url = '${Config.baseUrl}/user/sensor/sensor-1';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final sensorRecords = jsonResponse['data'][0];
        // Group by device_id to pick only the latest reading per sensor.

        setState(() {
          latestSensorData = sensorRecords;
          sensorLoading = false;
        });
      } else {
        setState(() {
          sensorError = 'Error fetching sensor data: ${response.statusCode}';
          sensorLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        sensorError = 'An error occurred while fetching sensor data.';
        sensorLoading = false;
      });
      print('Error fetching sensor data: $e');
    }
  }

  // --- Temperature Settings Functions ---
  Future<void> fetchTemperatureSetting() async {
    setState(() {
      settingsLoading = true;
      settingsError = null;
    });
    final url = '${Config.baseUrl}/user/temperatureSetting/';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final setting = jsonResponse['data'][0];
        setState(() {
          settingId = setting['_id'];
          minTempSetting = (setting['min_temp'] as num).toDouble();
          maxTempSetting = (setting['max_temp'] as num).toDouble();
          alertEnabled = setting['alert'] as bool;
          delayBeforeAlert = setting['delay_before_alert'] as int;
          _delayController.text = delayBeforeAlert.toString();
          settingsLoading = false;
        });
      } else if (response.statusCode == 404) {
        // No setting exists; allow creation.
        setState(() {
          settingsError = 'No temperature setting found. Create one below.';
          settingsLoading = false;
        });
      } else {
        setState(() {
          settingsError =
              'Error fetching temperature setting: ${response.statusCode}';
          settingsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        settingsError = 'Error fetching temperature setting: $e';
        settingsLoading = false;
      });
    }
  }

  String formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  @override
  void dispose() {
    _delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sensor Readings Section
    Widget sensorContent;
    if (sensorLoading) {
      sensorContent = const Center(child: CircularProgressIndicator());
    } else if (sensorError != null) {
      sensorContent = Center(child: Text(sensorError!));
    } else if (latestSensorData.isEmpty) {
      sensorContent = const Center(child: Text('No sensor data available.'));
    } else {
      sensorContent = Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Temperature: ${latestSensorData['temperature']}°C",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Battery: ${latestSensorData['battery']}%",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Last updated: ${formatDateTime(latestSensorData['createdAt'])}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Temperature Settings Form Section
    Widget settingsContent;
    if (settingsLoading) {
      settingsContent = const Center(child: CircularProgressIndicator());
    } else {
      settingsContent = Form(
        key: _settingsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (settingsError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(settingsError!,
                    style: const TextStyle(color: Colors.red)),
              ),
            Text("Min Temperature: ${minTempSetting.toStringAsFixed(1)}°C",
                style: const TextStyle(fontSize: 16)),
            Slider(
              value: minTempSetting,
              min: -20, // Now allows negative temperatures.
              max: 30,
              divisions: 50, // (30 - (-20)) = 50 steps
              label: minTempSetting.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  minTempSetting = value;
                  if (minTempSetting > maxTempSetting) {
                    maxTempSetting = minTempSetting;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            Text("Max Temperature: ${maxTempSetting.toStringAsFixed(1)}°C",
                style: const TextStyle(fontSize: 16)),
            Slider(
              value: maxTempSetting,
              min: 0,
              max: 50,
              divisions: 50,
              label: maxTempSetting.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  maxTempSetting = value;
                  if (maxTempSetting < minTempSetting) {
                    minTempSetting = maxTempSetting;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Temperature Alert: ",
                    style: TextStyle(fontSize: 16)),
                Switch(
                  value: alertEnabled,
                  onChanged: (value) {
                    setState(() {
                      alertEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Delay Before Alert (minutes):",
                style: const TextStyle(fontSize: 16)),
            TextFormField(
              controller: _delayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter delay in minutes",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a delay value";
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed < 0) {
                  return "Please enter a valid non-negative integer";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: settingsSubmitting ? null : updateTemperatureSetting,
            //     child: settingsSubmitting
            //         ? const SizedBox(
            //             width: 24,
            //             height: 24,
            //             child: CircularProgressIndicator(
            //               strokeWidth: 2,
            //               valueColor:
            //                   AlwaysStoppedAnimation<Color>(Colors.white),
            //             ),
            //           )
            //         : const Text("Save Settings"),
            //   ),
            // ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperatures"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchSensorData();
          await fetchTemperatureSetting();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sensor Readings Section
              const Text("Sensor Readings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              sensorContent,
              const Divider(height: 32, thickness: 2),
              // Temperature Settings Section
              const Text("Temperature Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              settingsContent,
            ],
          ),
        ),
      ),
    );
  }
}
