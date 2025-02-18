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
  List<Map<String, dynamic>> latestSensorData = [];

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
    final url = '${Config.baseUrl}/user/sensor';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<dynamic> sensorRecords = jsonResponse['data'];
        // Group by device_id to pick only the latest reading per sensor.
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
          latestSensorData = sensorMap.values.toList();
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
    final url = '${Config.baseUrl}/user/temperatureSetting/self';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final setting = jsonResponse['data'];
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
          settingsError = 'Error fetching temperature setting: ${response.statusCode}';
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

  Future<void> updateTemperatureSetting() async {
    if (!_settingsFormKey.currentState!.validate()) return;
    final int delayValue = int.tryParse(_delayController.text) ?? 0;
    setState(() {
      settingsSubmitting = true;
    });
    final url = settingId == null
        ? '${Config.baseUrl}/user/temperatureSetting/self'
        : '${Config.baseUrl}/user/temperatureSetting/$settingId';
    try {
      http.Response response;
      if (settingId == null) {
        // Create new temperature setting (restaurant_id is derived from token in the backend)
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${widget.token}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'min_temp': minTempSetting,
            'max_temp': maxTempSetting,
            'alert': alertEnabled,
            'delay_before_alert': delayValue,
          }),
        );
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Temperature setting created successfully')),
          );
          fetchTemperatureSetting();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating setting: ${response.statusCode}')),
          );
        }
      } else {
        // Update existing temperature setting.
        response = await http.put(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${widget.token}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'min_temp': minTempSetting,
            'max_temp': maxTempSetting,
            'alert': alertEnabled,
            'delay_before_alert': delayValue,
          }),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Temperature setting updated successfully')),
          );
          fetchTemperatureSetting();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating setting: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() {
      settingsSubmitting = false;
    });
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
      sensorContent = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: latestSensorData.length,
        itemBuilder: (context, index) {
          final sensor = latestSensorData[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Sensor: ${sensor['device_id']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Temperature: ${sensor['uplink_message']['decoded_payload']['temperature']}°C"),
                  Text("Battery: ${sensor['uplink_message']['decoded_payload']['battery']}%"),
                  Text("Last updated: ${formatDateTime(sensor['createdAt'])}"),
                ],
              ),
            ),
          );
        },
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
                child: Text(settingsError!, style: const TextStyle(color: Colors.red)),
              ),
            Text("Min Temperature: ${minTempSetting.toStringAsFixed(1)}°C", style: const TextStyle(fontSize: 16)),
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
            Text("Max Temperature: ${maxTempSetting.toStringAsFixed(1)}°C", style: const TextStyle(fontSize: 16)),
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
                const Text("Temperature Alert: ", style: TextStyle(fontSize: 16)),
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
            Text("Delay Before Alert (minutes):", style: const TextStyle(fontSize: 16)),
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
            Center(
              child: ElevatedButton(
                onPressed: settingsSubmitting ? null : updateTemperatureSetting,
                child: settingsSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text("Save Settings"),
              ),
            ),
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
              const Text("Sensor Readings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              sensorContent,
              const Divider(height: 32, thickness: 2),
              // Temperature Settings Section
              const Text("Temperature Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              settingsContent,
            ],
          ),
        ),
      ),
    );
  }
}
