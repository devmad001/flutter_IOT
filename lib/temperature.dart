import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? selectedSensorId;
  String? selectedSensorName = "";
  // --- Temperature Settings State ---
  bool settingsLoading = true;
  bool settingsSubmitting = false;
  String? settingsError;
  double minTempSetting = 5;
  double maxTempSetting = 10;
  bool alertEnabled = false;
  int delayBeforeAlert = 0;
  String? settingId; // Will be non-null if a setting exists
  List<Map<String, dynamic>> temperatureSettings =
      []; // New state variable for list of settings
  final TextEditingController _delayController = TextEditingController();
  final _settingsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    fetchTemperatureSetting();
  }

  // --- Sensor Data Functions ---
  Future<void> fetchSensorData() async {
    if (selectedSensorId == null) return;

    setState(() {
      sensorLoading = true;
      sensorError = null;
    });
    final url = '${Config.baseUrl}/user/sensor/$selectedSensorId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final sensorRecords = jsonResponse['data'];

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
        final settings = jsonResponse['data'];

        if (settings != null && settings.isNotEmpty) {
          setState(() {
            temperatureSettings = List<Map<String, dynamic>>.from(settings);
            // Set the first setting as the current one
            final firstSetting = settings[0];
            settingId = firstSetting['_id'];
            minTempSetting = (firstSetting['min_temp'] as num).toDouble();
            maxTempSetting = (firstSetting['max_temp'] as num).toDouble();
            alertEnabled = firstSetting['alert'] as bool;
            delayBeforeAlert = firstSetting['delay_before_alert'] as int;
            _delayController.text = delayBeforeAlert.toString();
            settingsLoading = false;
          });
        } else {
          setState(() {
            settingsError = 'No temperature settings found. Create one below.';
            settingsLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
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
    final l10n = AppLocalizations.of(context)!;

    // Sensor Readings Section
    Widget sensorContent;
    if (selectedSensorId == null) {
      sensorContent = Center(
        child: Text(l10n.selectSensorPrompt),
      );
    } else if (sensorLoading) {
      sensorContent = const Center(child: CircularProgressIndicator());
    } else if (sensorError != null) {
      sensorContent = Center(child: Text(sensorError!));
    } else if (latestSensorData.isEmpty) {
      sensorContent = Center(child: Text(l10n.noSensorData));
    } else {
      sensorContent = Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedSensorName ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.temperatureValue(
                    latestSensorData['temperature'].toString()),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              latestSensorData['battery'] != null
                  ? Text(
                      l10n.batteryValue(latestSensorData['battery'].toString()),
                      style: const TextStyle(fontSize: 18),
                    )
                  : const SizedBox(height: 8),
              Text(
                l10n.lastUpdated(formatDateTime(latestSensorData['createdAt'])),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Temperature Settings List Section
    Widget settingsListContent;
    if (settingsLoading) {
      settingsListContent = const Center(child: CircularProgressIndicator());
    } else if (temperatureSettings.isEmpty) {
      settingsListContent = Center(
        child: Text(l10n.noTemperatureSettings),
      );
    } else {
      settingsListContent = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: temperatureSettings.length,
        itemBuilder: (context, index) {
          final setting = temperatureSettings[index];
          final isSelected = settingId == setting['_id'];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isSelected ? Colors.blue.withOpacity(0.1) : null,
            child: ListTile(
              leading: Icon(
                Icons.thermostat,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              title: Text(
                "  ${setting['sensor_id']}",
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${l10n.minTemp(setting['min_temp'].toString())}, ${l10n.maxTemp(setting['max_temp'].toString())}",
                  ),
                  Text(
                    setting['alert'] ? l10n.alertEnabled : l10n.alertDisabled,
                    style: TextStyle(
                      color: setting['alert'] ? Colors.red : Colors.grey,
                    ),
                  ),
                  Text(
                    l10n.delayMinutes(setting['delay_before_alert'].toString()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  settingId = setting['_id'];
                  selectedSensorId = setting['dev_eui'];
                  selectedSensorName = setting['sensor_id'];
                  minTempSetting = (setting['min_temp'] as num).toDouble();
                  maxTempSetting = (setting['max_temp'] as num).toDouble();
                  alertEnabled = setting['alert'] as bool;
                  delayBeforeAlert = setting['delay_before_alert'] as int;
                  _delayController.text = delayBeforeAlert.toString();
                });
                fetchSensorData();
              },
            ),
          );
        },
      );
    }

    // Temperature Settings Form Section
    Widget settingsFormContent;
    if (settingsLoading) {
      settingsFormContent = const Center(child: CircularProgressIndicator());
    } else {
      settingsFormContent = Form(
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
            Text(l10n.minTemperature(minTempSetting.toStringAsFixed(1)),
                style: const TextStyle(fontSize: 16)),
            Slider(
              value: minTempSetting,
              min: -20,
              max: 100,
              divisions: 50,
              label: minTempSetting.toStringAsFixed(1),
              activeColor: Colors.grey,
              inactiveColor: Colors.grey.shade300,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text(l10n.maxTemperature(maxTempSetting.toStringAsFixed(1)),
                style: const TextStyle(fontSize: 16)),
            Slider(
              value: maxTempSetting,
              min: 0,
              max: 100,
              divisions: 50,
              label: maxTempSetting.toStringAsFixed(1),
              activeColor: Colors.grey,
              inactiveColor: Colors.grey.shade300,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(l10n.temperatureAlert,
                    style: const TextStyle(fontSize: 16)),
                Switch(
                  value: alertEnabled,
                  activeColor: Colors.grey,
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.delayBeforeAlert, style: const TextStyle(fontSize: 16)),
            TextFormField(
              controller: _delayController,
              keyboardType: TextInputType.number,
              enabled: false,
              decoration: InputDecoration(
                hintText: l10n.enterDelayMinutes,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterDelay;
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed < 0) {
                  return l10n.enterValidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return Scaffold(
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
              const SizedBox(height: 60),
              Text(
                l10n.temperatures,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.sensorList,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              settingsListContent,
              const Divider(height: 32, thickness: 2),
              Text(l10n.currentState,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              sensorContent,
              const Divider(height: 32, thickness: 2),
              Text(l10n.temperatureSetting,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              settingsFormContent,
            ],
          ),
        ),
      ),
    );
  }
}
