import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:guardstar/config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:guardstar/home.dart';

class ReportPage extends StatefulWidget {
  final String token;
  const ReportPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String _selectedPeriod = 'thisWeek';
  bool _isCustomDateEnabled = false;
  bool _showDatePicker = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _updateDateRange();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'thisWeek':
        _rangeStart = now.subtract(Duration(days: now.weekday - 1));
        _rangeEnd = now;
        _showDatePicker = false;
        break;
      case 'thisMonth':
        _rangeStart = DateTime(now.year, now.month, 1);
        _rangeEnd = now;
        _showDatePicker = false;
        break;
      case 'custom':
        _isCustomDateEnabled = true;
        _showDatePicker = true;
        break;
    }
  }

  Future<void> _downloadReport() async {
    if (_rangeStart == null || _rangeEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range first')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (!status.isGranted) {
        throw Exception('Storage permission is required to save the report');
      }

      final url = Uri.parse('${Config.baseUrl}/user/report/pdf').replace(
        queryParameters: {
          'startDate': _rangeStart!.toIso8601String(),
          'endDate': _rangeEnd!.toIso8601String(),
          'period': _selectedPeriod,
        },
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Create PDF document
        final pdf = pw.Document();

        // Add content to PDF
        pdf.addPage(
          pw.MultiPage(
            build: (context) => [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Report for ${DateFormat('MMM dd, yyyy').format(_rangeStart!)} - ${DateFormat('MMM dd, yyyy').format(_rangeEnd!)}',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Opening Checks',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(data['openingChecks']?.toString() ?? 'No data available'),
              pw.SizedBox(height: 10),
              pw.Text('Closing Checks',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(data['closingChecks']?.toString() ?? 'No data available'),
              pw.SizedBox(height: 10),
              pw.Text('Temperature Readings',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(data['temperatureReadings']?.toString() ??
                  'No data available'),
              pw.SizedBox(height: 10),
              pw.Text('Incidents Logged',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(data['incidents']?.toString() ?? 'No data available'),
            ],
          ),
        );

        // Save PDF to file
        final output = await getExternalStorageDirectory();
        if (output == null) {
          throw Exception('Could not access external storage');
        }

        final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${output.path}/$fileName');
        await file.writeAsBytes(await pdf.save());

        // Open the PDF file
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          throw Exception('Could not open the PDF file');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report downloaded successfully')),
        );
      } else {
        throw Exception('Failed to download report: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading report: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your report frequency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please choose the report range below',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedPeriod,
              items: const [
                DropdownMenuItem(value: 'thisWeek', child: Text('This Week')),
                DropdownMenuItem(value: 'thisMonth', child: Text('This Month')),
                DropdownMenuItem(value: 'custom', child: Text('Custom Range')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriod = newValue;
                    _updateDateRange();
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_isCustomDateEnabled && _showDatePicker) ...[
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: CalendarFormat.month,
                rangeSelectionMode: RangeSelectionMode.enforced,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    if (_rangeStart == null ||
                        (_rangeStart != null && _rangeEnd != null)) {
                      _rangeStart = selectedDay;
                      _rangeEnd = null;
                    } else {
                      _rangeEnd = selectedDay;
                      _showDatePicker = false;
                    }
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    // Handle format change if needed
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            if (_rangeStart != null && _rangeEnd != null) ...[
              Text(
                'Selected Range: ${DateFormat('MMM dd, yyyy').format(_rangeStart!)} - ${DateFormat('MMM dd, yyyy').format(_rangeEnd!)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'What the report will contain:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReportItem(Icons.check_box, 'Opening Checks'),
                    const SizedBox(height: 8),
                    _buildReportItem(
                        Icons.check_box_outlined, 'Closing Checks'),
                    const SizedBox(height: 8),
                    _buildReportItem(Icons.thermostat, 'Temperature Readings'),
                    const SizedBox(height: 8),
                    _buildReportItem(Icons.report_problem, 'Incidents Logged'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isDownloading ? null : _downloadReport,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.download),
                label:
                    Text(_isDownloading ? 'Downloading...' : 'Download Report'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[900]),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
