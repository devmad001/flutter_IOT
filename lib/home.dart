import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/opening_checklist.dart';
import 'package:guardstar/closing_checklist.dart';
import 'package:guardstar/create_incident.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guardstar/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:guardstar/providers/metrics_provider.dart';
import 'package:guardstar/providers/socket_provider.dart';
import 'package:guardstar/providers/sensor_data_provider.dart';

final baseUrl = dotenv.env['BASE_URL'];

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Providers
  SocketProvider? _socketProvider;
  SensorDataProvider? _sensorDataProvider;
  Function(dynamic)? _socketCallback;

  // State variables
  bool isLoading = false;
  bool openingChecklistCompleted = false;
  bool closingChecklistCompleted = false;
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  // Date range for temperature history
  DateTimeRange? selectedDateRange;
  List<Map<String, dynamic>> temperatureHistory = [];
  bool isHistoryLoading = false;
  bool _isInitialized = false;
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
    _initializeProviders();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _flashAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_flashController);
  }

  void _initializeProviders() {
    if (!mounted) return;

    _socketProvider = Provider.of<SocketProvider>(context, listen: false);
    _sensorDataProvider =
        Provider.of<SensorDataProvider>(context, listen: false);

    // Initialize socket with sensor data provider
    fetchSensorData();
    fetchChecklistStatus();
    setState(() {
      isHistoryLoading = true;
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _flashController.dispose();
    if (_socketCallback != null && _socketProvider != null) {
      try {
        //_socketProvider?.disconnect();
      } catch (e) {
        print('Error during socket cleanup: $e');
      }
    }
    super.dispose();
  }

  // void _handleSensorUpdate(dynamic data) {
  //   if (!mounted) return;
  //   _sensorDataProvider?.updateSensorData(data);
  // }

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
    String url = '';
    if (type == 'opening') {
      url = '$baseUrl/user/restaurant/open-checklist';
    } else {
      url = '$baseUrl/user/restaurant/close-checklist';
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data['completed'];
      }
    } catch (e) {
      print('Error fetching  checklist: $e');
    }
    return false;
  }

  void _navigateTo(String section) {
    Widget page;
    if (section == 'opening') {
      page = SidebarLayout(
        token: widget.token,
        content: OpeningChecklistPage(token: widget.token),
        title: 'HOME',
      );
    } else {
      page = SidebarLayout(
        token: widget.token,
        content: ClosingChecklistPage(token: widget.token),
        title: 'HOME',
      );
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
          builder: (context) => SidebarLayout(
                token: widget.token,
                content: CreateIncidentPage(token: widget.token),
                title: 'HOME',
              )),
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
      _sensorDataProvider?.setLoading(true);
      final response = await http.get(
        Uri.parse('$baseUrl/user/temperatureSetting'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> sensorRecords = data['data'];
        Map<String, Map<String, dynamic>> temperatureData = {};
        List<Map<String, dynamic>> sensorData = [];
        for (var record in sensorRecords) {
          final url = '$baseUrl/user/sensor/' + record['dev_eui'];
          final resTemperture = await http.get(
            Uri.parse(url),
            headers: {'Authorization': 'Bearer ${widget.token}'},
          );
          if (resTemperture.statusCode == 200) {
            final dataTemperture = json.decode(resTemperture.body);

            final temperature = dataTemperture['data']['temperature'];
            final battery = dataTemperture['data']['battery'];

            temperatureData[record['dev_eui']] = {
              'temperature': temperature,
              'battery': battery,
            };
          }
        }
        print("#########"); 
        sensorData = sensorRecords
            .map((record) => {
                  'dev_eui': record['dev_eui'],
                  'device_id': record['sensor_id'],
                  'restaurantName':
                      record['restaurant_id']['name'] ?? 'Unknown Restaurant',
                  'temperature': temperatureData[record['dev_eui']]
                          ?['temperature'] ??
                      '--',
                  'battery':
                      temperatureData[record['dev_eui']]?['battery'] ?? '--',
                  'timestamp': DateTime.now()
                      .toIso8601String(), // Will be updated by socket
                  'min_temp': record['min_temp'] ?? 0,
                  'max_temp': record['max_temp'] ?? 5,
                  'alert':record['alert'] ?? false,
                })
            .toList();

        _sensorDataProvider?.setSensorData(sensorData);
      } else {
        _sensorDataProvider?.setError('Failed to fetch sensor data');
      }
    } catch (e) {
      _sensorDataProvider?.setError('Error fetching sensor data: $e');
    }
  }

  void _showTemperatureAlert(
      String deviceId, double temperature, double minTemp, double maxTemp) {
    //if (!_isInitialized) return;

    if (!mounted) return;

    print("@@@@@@");
    print(deviceId);
    print(temperature);
    print(minTemp);
    print(maxTemp);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Center(
            child: Text(
              'Warning',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Text(
                ' $deviceId \n\n'
                'OUTSIDE OF SAFE TEMPERATURE THRESHOLD',
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: SizedBox(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: const Text('Dismiss'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSensorBoxes() {
    return Consumer<SensorDataProvider>(
      builder: (context, sensorProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final sensorData = sensorProvider.sensorData;

        if (sensorProvider.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(sensorProvider.errorMessage!,
                style: const TextStyle(color: Colors.red)),
          );
        }

        if (sensorData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(l10n.noSensorData),
          );
        }

        return Consumer<MetricsProvider>(
          builder: (context, metricsProvider, child) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: sensorData.map((sensor) {
                final deviceId = sensor['device_id'] ?? l10n.unknownRestaurant;
                final restaurantName =
                    sensor['restaurantName'] ?? l10n.unknownRestaurant;
                final temperature = sensor['temperature']?.toString() ?? '--';
                final battery = sensor['battery']?.toString() ?? '--';
                final timestamp = sensor['timestamp'] ?? '--';
                final minTemp = (sensor['min_temp'] ?? 0).toDouble();
                final maxTemp = (sensor['max_temp'] ?? 5).toDouble();

                String displayTemp = temperature;
                if (temperature != '--') {
                  try {
                    final tempValue = double.parse(temperature);
                    displayTemp =
                        metricsProvider.getTemperatureWithUnit(tempValue);

                    // _showTemperatureAlert(
                    //     deviceId, tempValue, minTemp, maxTemp);
                  } catch (e) {
                    displayTemp = '$temperature°C';
                  }
                }

                final isOutOfRange = temperature != '--' &&
                        (double.tryParse(temperature) ?? 0) < minTemp ||
                    (double.tryParse(temperature) ?? 0) > maxTemp;

                return AnimatedBuilder(
                  animation: _flashAnimation,
                  builder: (context, child) {
                    Color borderColor = Colors.green;
                    if (isOutOfRange) {
                      borderColor = Color.lerp(
                          Colors.white, Colors.red, _flashAnimation.value)!;
                    }

                    return Container(
                      width: 180,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(l10n.temperature),
                              Text(
                                displayTemp,
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(l10n.battery),
                          //     Text(
                          //       '$battery%',
                          //       style: TextStyle(
                          //         color: (double.tryParse(battery) ?? 0) > 20
                          //             ? Colors.green
                          //             : Colors.red,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 4),
                          // Text(
                          //   l10n.lastUpdated(_formatTimestamp(timestamp)),
                          //   style: const TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      if (timestamp == '--' || timestamp.isEmpty) {
        return 'N/A';
      }
      return DateTime.parse(timestamp).toLocal().toString().split('.')[0];
    } catch (e) {
      print('Error parsing timestamp: $timestamp');
      return 'N/A';
    }
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
        print(sensorData);
        // Create temporary variables for processing
        final List<String> newLabels = [];
        final Map<String, List<double>> newDataByDevice = {};

        // First pass: collect all unique dates and validate them
        for (var item in sensorData) {
          try {
            final date = item['_id']['date'];
            if (date != null &&
                date.toString().isNotEmpty &&
                !newLabels.contains(date)) {
              // Validate the date format
              DateTime.parse(date);
              newLabels.add(date);
            }
          } catch (e) {
            print('Error processing date: ${item['_id']['date']}');
            continue;
          }
        }

        // Sort dates chronologically
        newLabels.sort((a, b) {
          try {
            return DateTime.parse(a).compareTo(DateTime.parse(b));
          } catch (e) {
            print('Error sorting dates: $a, $b');
            return 0;
          }
        });

        // Second pass: process data for each device
        for (var item in sensorData) {
          try {
            final date = item['_id']['date'];
            if (date == null || date.toString().isEmpty) continue;

            final deviceId = item['_id']['device_id'];
            final avgTemp = double.tryParse(
                    item['averageTemperature']?.toString() ?? '0') ??
                0.0;

            // Initialize device data array if not exists
            if (!newDataByDevice.containsKey(deviceId)) {
              newDataByDevice[deviceId] = List.filled(newLabels.length, 0.0);
            }

            // Update device data at the correct index
            final dateIndex = newLabels.indexOf(date);
            if (dateIndex != -1) {
              newDataByDevice[deviceId]![dateIndex] = avgTemp;
            }
          } catch (e) {
            print('Error processing sensor data: $e');
            continue;
          }
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
    final l10n = AppLocalizations.of(context)!;

    if (selectedDateRange == null) {
      selectedDateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 8)),
        end: DateTime.now(),
      );
      fetchTemperatureHistory();
    }

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
              Text(
                l10n.temperatureHistory,
                style: const TextStyle(
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
                ? Center(child: CircularProgressIndicator())
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
                                try {
                                  final date = DateTime.parse(
                                      chartLabels[value.toInt()]);
                                  return Text('${date.day}/${date.month}');
                                } catch (e) {
                                  print(
                                      'Error parsing date: ${chartLabels[value.toInt()]}');
                                  return const Text('');
                                }
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

    return Consumer<SensorDataProvider>(
      builder: (context, sensorProvider, child) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 60.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        l10n.menuHome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildChecklistItem(l10n.openingChecklist,
                        openingChecklistCompleted, 'opening'),
                    _buildChecklistItem(l10n.closingChecklist,
                        closingChecklistCompleted, 'closing'),
                    _buildIncidentButton(),
                    const SizedBox(height: 20),
                    _buildSensorBoxes(),
                    const SizedBox(height: 20),
                    _buildTemperatureHistoryChart(),
                  ],
                ),
              );
      },
    );
  }
}
