import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:guardstar/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:guardstar/home.dart';
import 'package:guardstar/services/pdf_service.dart';
import 'package:provider/provider.dart';
import 'package:guardstar/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

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

  Future<bool> checkAndRequestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _downloadReport() async {
    if (_rangeStart == null || _rangeEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectDateFirst)),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
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
        print("@@@@@@@@######");

        // Get current language code from provider
        final languageProvider =
            Provider.of<LanguageProvider>(context, listen: false);
        final currentLanguageCode = languageProvider.currentLocale.languageCode;

        // Cast the data to the expected type
        final reportData = Map<String, dynamic>.from(data['reportData']);
        reportData['openingTasks'] =
            List<Map<String, dynamic>>.from(data['reportData']['openingTasks']);
        reportData['closingTasks'] =
            List<Map<String, dynamic>>.from(data['reportData']['closingTasks']);
        reportData['sensorData'] =
            List<Map<String, dynamic>>.from(data['reportData']['sensorData']);
        reportData['incidents'] =
            List<Map<String, dynamic>>.from(data['reportData']['incidents']);

        // Get temporary directory for file storage
        final output = await getTemporaryDirectory();

        try {
          // Generate PDF using the service
          final pdf = await PdfService.generateReport(
            startDate: _rangeStart!,
            endDate: _rangeEnd!,
            data: reportData,
            languageCode: currentLanguageCode,
          );

          // Save PDF to a temporary file
          final fileName =
              'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
          final file = File('${output.path}/$fileName');
          await file.writeAsBytes(await pdf.save());

          final params = SaveFileDialogParams(
            sourceFilePath: file.path,
            fileName: fileName,
          );
          await FlutterFileDialog.saveFile(params: params);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.downloadSuccess)),
          );
        } catch (e) {
          if (e.toString().contains('TooManyPagesException')) {
            // If the report is too large, try to generate it in chunks
            final chunkSize = 30; // Number of days per chunk
            final totalDays = _rangeEnd!.difference(_rangeStart!).inDays;
            final numChunks = (totalDays / chunkSize).ceil();

            for (var i = 0; i < numChunks; i++) {
              final chunkStart =
                  _rangeStart!.add(Duration(days: i * chunkSize));
              var chunkEnd = chunkStart.add(Duration(days: chunkSize - 1));
              if (chunkEnd.isAfter(_rangeEnd!)) {
                chunkEnd = _rangeEnd!;
              }

              final chunkData = Map<String, dynamic>.from(reportData);
              // Filter data for the current chunk
              chunkData['openingTasks'] =
                  (reportData['openingTasks'] as List).where((task) {
                final taskDate = DateTime.parse(task['createdAt']);
                return taskDate.isAfter(
                        chunkStart.subtract(const Duration(days: 1))) &&
                    taskDate.isBefore(chunkEnd.add(const Duration(days: 1)));
              }).toList();

              chunkData['closingTasks'] =
                  (reportData['closingTasks'] as List).where((task) {
                final taskDate = DateTime.parse(task['createdAt']);
                return taskDate.isAfter(
                        chunkStart.subtract(const Duration(days: 1))) &&
                    taskDate.isBefore(chunkEnd.add(const Duration(days: 1)));
              }).toList();

              chunkData['sensorData'] =
                  (reportData['sensorData'] as List).where((sensor) {
                final sensorDate = DateTime.parse(sensor['_id']['date']);
                return sensorDate.isAfter(
                        chunkStart.subtract(const Duration(days: 1))) &&
                    sensorDate.isBefore(chunkEnd.add(const Duration(days: 1)));
              }).toList();

              chunkData['incidents'] =
                  (reportData['incidents'] as List).where((incident) {
                final incidentDate = DateTime.parse(incident['reportedAt']);
                return incidentDate.isAfter(
                        chunkStart.subtract(const Duration(days: 1))) &&
                    incidentDate
                        .isBefore(chunkEnd.add(const Duration(days: 1)));
              }).toList();

              final chunkPdf = await PdfService.generateReport(
                startDate: chunkStart,
                endDate: chunkEnd,
                data: chunkData,
                languageCode: currentLanguageCode,
              );

              final chunkFileName =
                  'report_${DateTime.now().millisecondsSinceEpoch}_part${i + 1}.pdf';
              final chunkFile = File('${output.path}/$chunkFileName');
              await chunkFile.writeAsBytes(await chunkPdf.save());

              final chunkParams = SaveFileDialogParams(
                sourceFilePath: chunkFile.path,
                fileName: chunkFileName,
              );
              await FlutterFileDialog.saveFile(params: chunkParams);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.downloadSuccess)),
            );
          } else {
            rethrow;
          }
        }
      } else {
        print(response.statusCode);
        throw Exception('Failed to download report: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.downloadError(e.toString()))),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              l10n.menuReports,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectReportFrequency,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chooseReportRange,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedPeriod,
              items: [
                DropdownMenuItem(value: 'thisWeek', child: Text(l10n.thisWeek)),
                DropdownMenuItem(
                    value: 'thisMonth', child: Text(l10n.thisMonth)),
                DropdownMenuItem(
                    value: 'custom', child: Text(l10n.customRange)),
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
                l10n.selectedRange(
                    DateFormat('MMM dd, yyyy').format(_rangeStart!),
                    DateFormat('MMM dd, yyyy').format(_rangeEnd!)),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.reportContents,
                style: const TextStyle(
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
                    _buildReportItem(Icons.check_box, l10n.openingChecks),
                    const SizedBox(height: 8),
                    _buildReportItem(
                        Icons.check_box_outlined, l10n.closingChecks),
                    const SizedBox(height: 8),
                    _buildReportItem(
                        Icons.thermostat, l10n.temperatureReadings),
                    const SizedBox(height: 8),
                    _buildReportItem(
                        Icons.report_problem, l10n.incidentsLogged),
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
                label: Text(
                    _isDownloading ? l10n.downloading : l10n.downloadReport),
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
