import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfService {
  static pw.Font? _chineseFont;
  static pw.Font? _defaultFont;

  static Future<pw.Font> _getChineseFont() async {
    if (_chineseFont == null) {
      final fontData = await rootBundle
          .load('assets/fonts/NotoSansSC-VariableFont_wght.ttf');
      _chineseFont = pw.Font.ttf(fontData);
    }
    return _chineseFont!;
  }

  static pw.Font _getDefaultFont() {
    if (_defaultFont == null) {
      _defaultFont = pw.Font.helvetica();
    }
    return _defaultFont!;
  }

  static pw.TextStyle _getTextStyle(
      {PdfColor? color, String languageCode = 'en'}) {
    final font = languageCode == 'zh' ? _chineseFont : _getDefaultFont();
    return pw.TextStyle(
      font: font,
      color: color,
    );
  }

  static String _getMappedLanguageCode(String languageCode) {
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

  static String _getLocalizedText(
      Map<String, dynamic> task, String field, String languageCode) {
    String mappedLanguageCode = _getMappedLanguageCode(languageCode);
    return task['${field}_$mappedLanguageCode'] ?? task['${field}_en'] ?? '';
  }

  static pw.Widget _buildHeader(
      String title, String value, String languageCode) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(title,
                      style: _getTextStyle(languageCode: languageCode)),
                  pw.Text(value,
                      style: _getTextStyle(languageCode: languageCode)),
                ],
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Actions',
                      style: _getTextStyle(languageCode: languageCode)),
                  pw.Text('0',
                      style: _getTextStyle(languageCode: languageCode)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTaskRow(Map<String, dynamic> task, bool isCompleted,
      bool isSection, String languageCode) {
    final backgroundColor = isSection ? PdfColors.grey300 : PdfColors.white;
    final contentBackgroundColor = isCompleted && task['content'] == null
        ? PdfColor.fromHex('#81b532')
        : backgroundColor;
    final contentTextColor = isCompleted && task['content'] == null
        ? PdfColors.white
        : PdfColors.black;

    String title = _getLocalizedText(task, 'title', languageCode);
    String content = _getLocalizedText(task, 'content', languageCode);

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        border: !isSection
            ? pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 2))
            : null,
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(title,
                  style: _getTextStyle(languageCode: languageCode)),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: task['isDateRecord']
                  ? PdfColors.white
                  : contentBackgroundColor,
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  task['isDateRecord']
                      ? DateFormat('dd MMM yyyy hh:mm a')
                              .format(DateTime.parse(task['createdAt'])) +
                          ' GMT'
                      : (isCompleted && content.isEmpty)
                          ? 'Yes'
                          : content,
                  style: _getTextStyle(
                    color: task['isDateRecord']
                        ? PdfColors.black
                        : contentTextColor,
                    languageCode: languageCode,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildIncidentRow(
      Map<String, dynamic> task, String languageCode) {
    bool status = task['status'] == "Resolved";

    final backgroundColor =
        status ? PdfColor.fromHex('#81b532') : PdfColors.red;

    String incident = _getLocalizedText(task, 'incident', languageCode);

    return pw.Container(
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(incident,
                  style: _getTextStyle(languageCode: languageCode)),
              color: backgroundColor,
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: backgroundColor,
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  status ? 'Yes' : 'No',
                  style: _getTextStyle(
                    color: backgroundColor,
                    languageCode: languageCode,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTemperatureRowWithDate(
      String sensorId, String temperature, String languageCode) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 2)),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(sensorId,
                  style: _getTextStyle(languageCode: languageCode)),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  temperature + "°C",
                  style: _getTextStyle(languageCode: languageCode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<pw.Document> generateReport({
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic> data,
    required String languageCode,
  }) async {
    final pdf = pw.Document();
    if (languageCode == 'zh') {
      _chineseFont = await _getChineseFont();
    }

    // Calculate average temperatures
    final Map<String, double> averageTemperatures = {};
    for (final sensor in data['sensorData'] as List) {
      final deviceId = sensor['_id']['device_id'];
      final temp = sensor['averageTemperature'] as double;
      if (averageTemperatures.containsKey(deviceId)) {
        averageTemperatures[deviceId] =
            ((averageTemperatures[deviceId]! + temp) / 2);
      } else {
        averageTemperatures[deviceId] = temp;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          theme: pw.ThemeData.withFont(
            base: languageCode == 'zh' ? _chineseFont! : _getDefaultFont(),
            bold: languageCode == 'zh' ? _chineseFont! : _getDefaultFont(),
          ),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(50),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader('Flagged items', '0', languageCode),
                pw.SizedBox(height: 20),

                // Opening Tasks
                ...List<pw.Widget>.generate(
                  data['openingTasks'].length,
                  (index) {
                    final task = data['openingTasks'][index];
                    print(task['completeat']);
                    if (task['isTemperature'] == true &&
                        task['completeat'] != null) {
                      // Filter sensor data for the task's completedAt date
                      final taskDate = task['completeat'];
                      // Convert ISO timestamp to date-only format (YYYY-MM-DD)
                      final taskDateOnly = taskDate.substring(0, 10);
                      final relevantSensorData = data['sensorData']
                          .where(
                              (sensor) => sensor['_id']['date'] == taskDateOnly)
                          .toList();

                      // Calculate temperatures for the specific date
                      final Map<String, double> dateTemperatures = {};
                      for (final sensor in relevantSensorData) {
                        final deviceId = sensor['_id']['device_id'];
                        final temp = sensor['averageTemperature'] as double;
                        dateTemperatures[deviceId] = temp;
                      }

                      return pw.Column(
                        children: [
                          ...dateTemperatures.entries.map((entry) {
                            return _buildTemperatureRowWithDate(
                              entry.key,
                              '${entry.value.toStringAsFixed(2)}',
                              languageCode,
                            );
                          }).toList(),
                        ],
                      );
                    } else {
                      return _buildTaskRow(
                        task,
                        task['status'] == 'completed',
                        task['isSection'] == true,
                        languageCode,
                      );
                    }
                  },
                ),

                // Closing Tasks

                // Incident List Header
                pw.SizedBox(height: 20),
                _buildHeader('Incident List', '${data['incidents'].length}',
                    languageCode),
                pw.SizedBox(height: 10),

                ...List<pw.Widget>.generate(
                  data['incidents'].length,
                  (index) {
                    final task = data['incidents'][index];

                    return _buildIncidentRow(
                      task,
                      languageCode,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}
