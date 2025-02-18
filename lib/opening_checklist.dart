import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alpha/config.dart';
import 'dart:convert';

class OpeningChecklistPage extends StatefulWidget {
  final String token;

  const OpeningChecklistPage({Key? key, required this.token}) : super(key: key);

  @override
  _OpeningChecklistPageState createState() => _OpeningChecklistPageState();
}

class _OpeningChecklistPageState extends State<OpeningChecklistPage> {
  List<dynamic> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    // const url = 'http://10.14.174.81:3000/api/v1/user/checklist/opening';
    final url = '${Config.baseUrl}/user/checklist/opening';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tasks = data['tasks'];
          isLoading = false;
        });
      } else {
        print('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    // final url = 'http://10.14.174.81:3000/api/v1/user/checklist/$taskId';
    final url = '${Config.baseUrl}/user/checklist/$taskId';
    final status = isCompleted ? 'completed' : 'pending';

    try {
      await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );
      fetchTasks(); // Refresh tasks after updating
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // ✅ Fix: Added Scaffold
      appBar: AppBar(title: const Text('Opening Checklist')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('No tasks available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card( // ✅ Fix: Wrapped ListTile inside Card
                      child: ListTile(
                        title: Text(task['title']),
                        trailing: Checkbox(
                          value: task['status'] == 'completed',
                          onChanged: (value) {
                            if (value != null) {
                              updateTaskStatus(task['_id'], value);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
