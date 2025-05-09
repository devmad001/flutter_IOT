import 'package:flutter/material.dart';
import 'package:guardstar/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:guardstar/providers/sensor_data_provider.dart';
import 'package:guardstar/providers/metrics_provider.dart';

class OpeningChecklistPage extends StatefulWidget {
  final String token;

  const OpeningChecklistPage({Key? key, required this.token}) : super(key: key);

  @override
  _OpeningChecklistPageState createState() => _OpeningChecklistPageState();
}

class _OpeningChecklistPageState extends State<OpeningChecklistPage> {
  List<dynamic> tasks = [];
  bool isLoading = true;
  String dueTime = '';
  bool isChecklistCompleted = false;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  String tempInputValue = '';
  // Add a map to store controllers for each task
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    fetchTasks();
    fetchDueTime();
    fetchChecklistCompletionStatus();

    // Add scroll listener
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Dispose all text controllers
    _controllers.forEach((_, controller) => controller.dispose());
    // Remove scroll listener
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Add scroll listener method
  void _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  String formatTime(String dateTimeString) {
    try {
      // Parse the ISO datetime string
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Convert to CET timezone (UTC+1 or UTC+2 depending on daylight saving)
      final cetOffset = Duration(hours: dateTime.timeZoneOffset.inHours);
      final cetDateTime = dateTime.add(cetOffset);

      // Format the time in 12-hour format
      final formatter = DateFormat('h:mm a');
      return formatter.format(cetDateTime);
    } catch (e) {
      print('Error formatting time: $e');
      return dateTimeString;
    }
  }

  Future<void> fetchTasks() async {
    // const url = 'http://10.14.174.81:3000/api/v1/user/checklist/opening';
    final url = '${Config.baseUrl}/user/checklists/type/opening';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tasks = data;
          isLoading = false;
        });
      } else {
        print('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchDueTime() async {
    final url = '${Config.baseUrl}/user/restaurant/due-time';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dueTime = formatTime(data['openingDueTime'][0] ?? '');
        });
      } else {
        print('Failed to load due time');
      }
    } catch (e) {
      print('Error fetching due time: $e');
    }
  }

  Future<void> fetchChecklistCompletionStatus() async {
    final url = '${Config.baseUrl}/user/restaurant/open-checklist';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isChecklistCompleted = data['completed'] ?? false;
        });
      } else {
        print('Failed to load checklist completion status');
      }
    } catch (e) {
      print('Error fetching checklist completion status: $e');
    }
  }

  Future<void> updateTaskComment(String taskId, String comment) async {
    if (isChecklistCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Checklist is already completed. Cannot update tasks.')),
      );
      return;
    }

    final url = '${Config.baseUrl}/user/checklists/$taskId';
    final status = 'pending';

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> body = {
        'status': status,
      };
      if (comment != '') {
        body['comment'] =
            comment; // if the task is not content and the comment has, add the comment to the body
      }
      // Store current scroll position before fetching
      _scrollPosition = _scrollController.position.pixels;

      await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      await fetchTasks(); // Refresh tasks after updating

      // Wait for the next frame to ensure the list is built
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollPosition);
        }
      });

      setState(() {
        isLoading = false;
        tempInputValue = "";
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateTaskContent(
      String taskId, bool isCompleted, String content) async {
    if (isChecklistCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Checklist is already completed. Cannot update tasks.')),
      );
      return;
    }

    final url = '${Config.baseUrl}/user/checklists/$taskId';
    final status = isCompleted ? 'completed' : 'pending';

    if (content == "")
      return; // if the task is content and the content is empty, return

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> body = {
        'status': status,
      };

      body['content'] =
          content; // if the task is content and the content has, add the content to the body

      // Store current scroll position before fetching
      _scrollPosition = _scrollController.position.pixels;

      await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      await fetchTasks(); // Refresh tasks after updating

      // Wait for the next frame to ensure the list is built
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollPosition);
        }
      });

      setState(() {
        isLoading = false;
        tempInputValue = "";
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    if (isChecklistCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Checklist is already completed. Cannot update tasks.')),
      );
      return;
    }

    final url = '${Config.baseUrl}/user/checklists/$taskId';
    final status = isCompleted ? 'completed' : 'pending';

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> body = {
        'status': status,
      };

      // Store current scroll position before fetching
      _scrollPosition = _scrollController.position.pixels;

      await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      await fetchTasks(); // Refresh tasks after updating

      // Wait for the next frame to ensure the list is built
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollPosition);
        }
      });

      setState(() {
        isLoading = false;
        tempInputValue = "";
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateChecklistCompletion() async {
    if (isChecklistCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist is already completed.')),
      );
      return;
    }

    final url = '${Config.baseUrl}/user/restaurant/open-checklist';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'completed': true}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Checklist completion updated: ${data['message']}');
      } else {
        print('Failed to update checklist completion');
      }
    } catch (e) {
      print('Error updating checklist completion: $e');
    }
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

  void _checkAndShowCompletionMessage() {
    bool allCompleted = tasks.every((task) =>
        task['isSection'] == true ||
        task['comment'] != '' ||
        task['status'] == 'completed');
    if (allCompleted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text(AppLocalizations.of(context)!
                    .checklistCompletedSuccessfully),
                SizedBox(width: 8),
                Icon(Icons.check_box, color: Colors.green),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await updateChecklistCompletion();
                  Widget page;
                  page = SidebarLayout(
                    token: widget.token,
                    content: HomeScreen(token: widget.token),
                    title: 'HOME',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Optionally, show a message indicating not all tasks are completed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('could not complete')),
      );
    }
  }

  Color _getTemperatureColor(
      double temperature, double minTemp, double maxTemp) {
    if (temperature < minTemp || temperature > maxTemp) {
      return Colors.red;
    }
    return Colors.green;
  }

  Widget _buildTemperatureWidget(
      BuildContext context, List<dynamic> sensorData) {
    final metricsProvider = Provider.of<MetricsProvider>(context);
    return Consumer<SensorDataProvider>(
      builder: (context, sensorProvider, child) {
        if (sensorProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (sensorData.isEmpty) {
          return const Text('No temperature data available');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sensorData.length,
          itemBuilder: (context, index) {
            final sensor = sensorData[index];
            final deviceId = sensor['device_id'] ?? 'Unknown';
            final temperature = sensor['temperature']?.toString() ?? '--';
            final minTemp = (sensor['min_temp'] ?? 0).toDouble();
            final maxTemp = (sensor['max_temp'] ?? 5).toDouble();

            String displayTemp = temperature;
            if (temperature != '--') {
              try {
                final tempValue = double.parse(temperature);
                displayTemp = metricsProvider.getTemperatureWithUnit(tempValue);
              } catch (e) {
                displayTemp = '$temperature°C';
              }
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        deviceId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final metricsProvider = Provider.of<MetricsProvider>(context);
    final sensorProvider = Provider.of<SensorDataProvider>(context);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('No tasks available'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 60.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.openingChecklist,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isChecklistCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OPENING CHECKLISTS - TO BE COMPLETED BY $dueTime',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Tasks',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                itemCount: tasks.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  String mappedLanguageCode =
                                      _getMappedLanguageCode(
                                          Localizations.localeOf(context)
                                              .languageCode);
                                  String taskTitle =
                                      task['title_$mappedLanguageCode'] ??
                                          task['title_en'];
                                  String taskcontent =
                                      task['content_$mappedLanguageCode'] ??
                                          task['content_en'];

                                  if (task['isSection'] == true) {
                                    return Container(
                                      color: const Color.fromARGB(
                                          255, 130, 121, 212),
                                      child: ListTile(
                                        title: Text(taskTitle),
                                      ),
                                    );
                                  }

                                  Widget temperatureWidget =
                                      const SizedBox.shrink();
                                  if (task['isTemperature'] == true) {
                                    temperatureWidget = _buildTemperatureWidget(
                                        context, sensorProvider.sensorData);
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(taskTitle),
                                            if (task['comment'] != '')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  task['comment'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600],
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        subtitle: task['isInput'] == true
                                            ? TextField(
                                                controller:
                                                    _controllers.putIfAbsent(
                                                  task['_id'],
                                                  () => TextEditingController(
                                                      text: taskcontent),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    tempInputValue = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                ),
                                              )
                                            : null,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (task['comment'] == '') {
                                                  if (task['isInput'] == true) {
                                                    updateTaskContent(
                                                        task['_id'],
                                                        task['status'] !=
                                                            'completed',
                                                        tempInputValue != ""
                                                            ? tempInputValue
                                                            : taskcontent);
                                                  } else {
                                                    updateTaskStatus(
                                                      task['_id'],
                                                      task['status'] !=
                                                          'completed',
                                                    );
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: task['status'] ==
                                                                'completed' ||
                                                            task['comment'] !=
                                                                ''
                                                        ? Colors.green
                                                        : Colors.grey,
                                                    width: 2,
                                                  ),
                                                  color: task['status'] ==
                                                              'completed' ||
                                                          task['comment'] != ''
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                                child: Icon(
                                                  task['comment'] != ''
                                                      ? Icons.swap_horiz
                                                      : Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                if (task['status'] !=
                                                        'completed' &&
                                                    task['comment'] == "") {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      TextEditingController
                                                          commentController =
                                                          TextEditingController();
                                                      return AlertDialog(
                                                        title:
                                                            Text('Add Comment'),
                                                        content: TextField(
                                                          controller:
                                                              commentController,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Enter your comment here'),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              String comment =
                                                                  commentController
                                                                      .text;
                                                              updateTaskComment(
                                                                task['_id'],
                                                                comment,
                                                              );
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Submit'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Close'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (task['isTemperature'] == true)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: temperatureWidget,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ElevatedButton(
                            onPressed: _checkAndShowCompletionMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
