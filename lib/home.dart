import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/opening_checklist.dart';
import 'package:guardstar/closing_checklist.dart';
import 'package:guardstar/create_incident.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardstar/socket_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guardstar/widgets/app_bar.dart';

final baseUrl = dotenv.env['BASE_URL'];

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Checklist state
  bool isLoading = false;
  bool openingChecklistCompleted = false;
  bool closingChecklistCompleted = false;

  // Sensor state
  bool isSensorLoading = true;
  String? sensorErrorMessage;
  List<Map<String, dynamic>> sensorData = [];

  // Date range for temperature history
  DateTimeRange? selectedDateRange;
  List<Map<String, dynamic>> temperatureHistory = [];
  bool isHistoryLoading = false;

  // Add new state for chart data
  List<String> chartLabels = [];
  Map<String, List<double>> temperatureDataByDevice = {};
  List<Color> chartColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize socket connection
    SocketService.instance.initSocket(widget.token);
    // Subscribe to sensor updates
    SocketService.instance
        .subscribeToEvent('newSensorData', _handleSensorUpdate);

    // Fetch both checklist and sensor data
    //fetchChecklistStatus();
    fetchSensorData();
  }

  @override
  void dispose() {
    // Clean up socket connection
    SocketService.instance.disconnect();
    super.dispose();
  }

  void _handleSensorUpdate(dynamic data) {
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
    final l10n = AppLocalizations.of(context)!;
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
                isCompleted ? l10n.viewChecklist : l10n.clickToFill,
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
    final l10n = AppLocalizations.of(context)!;
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
            Text(
              l10n.addIncident,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                l10n.createIncident,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
        final minTemp = (sensor['min_temp'] ?? 0).toDouble();
        final maxTemp = (sensor['max_temp'] ?? 5).toDouble();

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

  Future<void> fetchTemperatureHistory() async {
    if (selectedDateRange == null) return;

    setState(() {
      isHistoryLoading = true;
    });

    try {
      final startDate = selectedDateRange!.start.toIso8601String();
      final endDate = selectedDateRange!.end.toIso8601String();

      final url = Uri.parse('$baseUrl/user/average-daily-temperature')
          .replace(queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      });

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> sensorData = data;

        // Create temporary variables for processing
        final List<String> newLabels = [];
        final Map<String, List<double>> newDataByDevice = {};

        // First pass: collect all unique dates
        for (var item in sensorData) {
          final date = item['_id']['date'];
          if (!newLabels.contains(date)) {
            newLabels.add(date);
          }
        }

        // Sort dates chronologically
        newLabels.sort();

        // Second pass: process data for each device
        for (var item in sensorData) {
          final date = item['_id']['date'];
          final deviceId = item['_id']['device_id'];
          final avgTemp = double.parse(item['averageTemperature'].toString());

          // Initialize device data array if not exists
          if (!newDataByDevice.containsKey(deviceId)) {
            newDataByDevice[deviceId] = List.filled(newLabels.length, 0.0);
          }

          // Update device data at the correct index
          final dateIndex = newLabels.indexOf(date);
          newDataByDevice[deviceId]![dateIndex] = avgTemp;
        }

        // Update state with processed data
        setState(() {
          temperatureHistory = List<Map<String, dynamic>>.from(sensorData);
          chartLabels = newLabels;
          temperatureDataByDevice = newDataByDevice;
          isHistoryLoading = false;
        });
      } else {
        setState(() {
          isHistoryLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error fetching temperature history: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isHistoryLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTemperatureHistoryChart() {
    // Set default date range if not selected
    if (selectedDateRange == null) {
      selectedDateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 8)),
        end: DateTime.now(),
      );
      // Fetch initial data
      fetchTemperatureHistory();
    }
    print(temperatureDataByDevice);
    // Generate line chart data for each device
    final lineBarsData = temperatureDataByDevice.entries.map((entry) {
      final deviceId = entry.key;
      final data = entry.value;
      final colorIndex =
          temperatureDataByDevice.keys.toList().indexOf(deviceId) %
              chartColors.length;
      final color = chartColors[colorIndex];

      return LineChartBarData(
        spots: data.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.toDouble());
        }).toList(),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.2),
        ),
      );
    }).toList();

    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Temperature History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange: selectedDateRange,
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDateRange = picked;
                    });
                    // Fetch new data when date range changes
                    fetchTemperatureHistory();
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - '
                  '${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Add legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: temperatureDataByDevice.keys.map((deviceId) {
              final colorIndex =
                  temperatureDataByDevice.keys.toList().indexOf(deviceId) %
                      chartColors.length;
              final color = chartColors[colorIndex];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    deviceId,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isHistoryLoading
                ? const Center(child: CircularProgressIndicator())
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toStringAsFixed(1)}°C');
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < chartLabels.length) {
                                final date =
                                    DateTime.parse(chartLabels[value.toInt()]);
                                return Text('${date.day}/${date.month}');
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: lineBarsData,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final deviceId = temperatureDataByDevice.keys
                                  .elementAt(spot.barIndex);
                              final color = chartColors[
                                  spot.barIndex % chartColors.length];
                              return LineTooltipItem(
                                '$deviceId\n${spot.y.toStringAsFixed(2)}°C',
                                TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // BUILD METHOD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // If either checklist or sensor data is still loading, show a loader.
    final isAnyLoading = isLoading || isSensorLoading;

    return SidebarLayout(
      token: widget.token,
      title: l10n.home,
      content: isAnyLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Checklist items
                  _buildChecklistItem(l10n.openingChecklist,
                      openingChecklistCompleted, 'opening'),
                  _buildChecklistItem(l10n.closingChecklist,
                      closingChecklistCompleted, 'closing'),
                  // Incident button
                  _buildIncidentButton(),
                  const SizedBox(height: 20),
                  // Sensor boxes showing latest sensor data with friendly names
                  _buildSensorBoxes(),
                  const SizedBox(height: 20),
                  // Temperature history chart
                  _buildTemperatureHistoryChart(),
                ],
              ),
            ),
    );
  }
}
