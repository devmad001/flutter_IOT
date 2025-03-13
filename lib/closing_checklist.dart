import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:guardstar/home.dart';
import 'package:flutter/scheduler.dart';

class ClosingChecklistPage extends StatefulWidget {
  final String token;

  const ClosingChecklistPage({Key? key, required this.token}) : super(key: key);

  @override
  _ClosingChecklistPageState createState() => _ClosingChecklistPageState();
}

class _ClosingChecklistPageState extends State<ClosingChecklistPage> {
  List<dynamic> tasks = [];
  bool isLoading = true;
  String dueTime = '';
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
          dueTime = formatTime(data['closingDueTime'][0] ?? '');
        });
      } else {
        print('Failed to load due time');
      }
    } catch (e) {
      print('Error fetching due time: $e');
    }
  }

  Future<void> fetchTasks() async {
    // const url = 'http://10.14.174.81:3000/api/v1/user/checklist/closing';

    final url = '${Config.baseUrl}/user/checklists/type/closing';
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

  Future<void> updateTaskContent(
      String taskId, bool isCompleted, String content) async {
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

  Future<void> updateTaskComment(String taskId, String comment) async {
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
        body['comment'] = comment;
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

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
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
    final url = '${Config.baseUrl}/user/restaurant/close-checklist';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('could not complete')),
      );
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      child: Text(
                        l10n.closingChecklist,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'CLOSING CHECKLISTS - TO BE COMPLETED BY $dueTime',
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

                                  return ListTile(
                                    title: Text(taskTitle),
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
                                            if (task['isInput'] == true) {
                                              updateTaskContent(
                                                  task['_id'],
                                                  task['status'] != 'completed',
                                                  tempInputValue != ""
                                                      ? tempInputValue
                                                      : taskcontent);
                                            } else {
                                              updateTaskStatus(
                                                task['_id'],
                                                task['status'] != 'completed',
                                              );
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
                                                        task['comment'] != ''
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
                                            if (task['status'] != 'completed' &&
                                                task['comment'] == "") {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  TextEditingController
                                                      commentController =
                                                      TextEditingController();
                                                  return AlertDialog(
                                                    title: Text('Add Comment'),
                                                    content: TextField(
                                                      controller:
                                                          commentController,
                                                      decoration: InputDecoration(
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Submit'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Close'),
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
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
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
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
