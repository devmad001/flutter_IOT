import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FontManager {
  static pw.Font? _chineseFont;
  static pw.Font? _defaultFont;

  static Future<pw.Font> getChineseFont() async {
    if (_chineseFont == null) {
      final fontData = await rootBundle
          .load('assets/fonts/NotoSansSC-VariableFont_wght.ttf');
      _chineseFont = pw.Font.ttf(fontData);
    }
    return _chineseFont!;
  }

  static pw.Font getDefaultFont() {
    if (_defaultFont == null) {
      _defaultFont = pw.Font.helvetica();
    }
    return _defaultFont!;
  }
}

class TextStyleManager {
  static pw.TextStyle getTextStyle({
    PdfColor? color,
    String languageCode = 'en',
  }) {
    final font = languageCode == 'zh'
        ? FontManager._chineseFont
        : FontManager.getDefaultFont();
    return pw.TextStyle(
      font: font,
      color: color,
    );
  }
}

class LanguageManager {
  static String getMappedLanguageCode(String languageCode) {
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

  static String getLocalizedText(
    Map<String, dynamic> task,
    String field,
    String languageCode,
  ) {
    String mappedLanguageCode = getMappedLanguageCode(languageCode);
    return task['${field}_$mappedLanguageCode'] ?? task['${field}_en'] ?? '';
  }
}

class PdfWidgetBuilder {
  static pw.Widget buildHeader(
      String title, String value, String languageCode) {
    return pw.Container(
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
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
                      style: TextStyleManager.getTextStyle(
                          languageCode: languageCode)),
                  pw.Text(value,
                      style: TextStyleManager.getTextStyle(
                          languageCode: languageCode)),
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
                      style: TextStyleManager.getTextStyle(
                          languageCode: languageCode)),
                  pw.Text('0',
                      style: TextStyleManager.getTextStyle(
                          languageCode: languageCode)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildTaskRow(
    Map<String, dynamic> task,
    bool isCompleted,
    bool isSection,
    String languageCode,
  ) {
    final backgroundColor = isSection ? PdfColors.grey300 : PdfColors.white;
    final contentBackgroundColor = isCompleted && task['content'] == null
        ? PdfColor.fromHex('#81b532')
        : backgroundColor;
    final contentTextColor = isCompleted && task['content'] == null
        ? PdfColors.white
        : PdfColors.black;

    String title =
        LanguageManager.getLocalizedText(task, 'title', languageCode);
    String content =
        LanguageManager.getLocalizedText(task, 'content', languageCode);

    return pw.Container(
      decoration: pw.BoxDecoration(
          color: isSection ? PdfColors.grey300 : backgroundColor,
          border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 2))),
      child: isSection
          ? pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: PdfColors.grey300,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 10,
                    child: pw.Text(title,
                        style: TextStyleManager.getTextStyle(
                            color: PdfColors.black,
                            languageCode: languageCode)),
                  ),
                ],
              ),
            )
          : pw.Row(
              children: [
                pw.Expanded(
                  flex: 7,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(title,
                        style: TextStyleManager.getTextStyle(
                            languageCode: languageCode)),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    color: task['isDateRecord'] || task['content'] != null
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
                        style: TextStyleManager.getTextStyle(
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

  static pw.Widget buildIncidentRow(
      Map<String, dynamic> task, String languageCode) {
    bool status = task['status'] == "Resolved";
    final backgroundColor =
        status ? PdfColor.fromHex('#81b532') : PdfColors.red;
    String incident =
        LanguageManager.getLocalizedText(task, 'incident', languageCode);

    return pw.Container(
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(incident,
                  style: TextStyleManager.getTextStyle(
                      languageCode: languageCode)),
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
                  style: TextStyleManager.getTextStyle(
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

  static pw.Widget buildTemperatureRowWithDate(
    String sensorId,
    String temperature,
    String languageCode,
  ) {
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
                  style: TextStyleManager.getTextStyle(
                      languageCode: languageCode)),
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
                  style:
                      TextStyleManager.getTextStyle(languageCode: languageCode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TemperaturePdfBuilder {
  static pw.Widget buildTemperatureSection(
    Map<String, dynamic> task,
    List<Map<String, dynamic>> sensorData,
    String languageCode,
  ) {
    if (task['isTemperature'] != true || task['completeat'] == null) {
      return pw.SizedBox.shrink();
    }
    final isCompleted = task['status'] == "completed";
    final taskDate = task['completeat'];
    final taskDateOnly = taskDate.substring(0, 10);
    final relevantSensorData = sensorData
        .where((sensor) => sensor['_id']['date'] == taskDateOnly)
        .toList();

    final Map<String, double> dateTemperatures = {};
    for (final sensor in relevantSensorData) {
      final deviceId = sensor['_id']['device_id'];
      final temp = sensor['averageTemperature'] as double;
      dateTemperatures[deviceId] = temp;
    }

    String title =
        LanguageManager.getLocalizedText(task, 'title', languageCode);

    final contentBackgroundColor =
        isCompleted ? PdfColor.fromHex('#81b532') : PdfColors.white;
    final contentTextColor = isCompleted ? PdfColors.white : PdfColors.black;

    return pw.Column(
      children: [
        // pw.Container(
        //   decoration: pw.BoxDecoration(
        //     color: PdfColors.grey300,
        //     border: pw.Border(
        //         bottom: pw.BorderSide(color: PdfColors.black, width: 2)),
        //   ),
        //   child: pw.Row(
        //     children: [
        //       pw.Expanded(
        //         flex: 7,
        //         child: pw.Container(
        //           padding: const pw.EdgeInsets.all(10),
        //           child: pw.Text(
        //             title,
        //             style: TextStyleManager.getTextStyle(
        //                 languageCode: languageCode),
        //           ),
        //         ),
        //       ),
        //       pw.Expanded(
        //         flex: 3,
        //         child: pw.Container(
        //           color: contentBackgroundColor,
        //           padding: const pw.EdgeInsets.all(10),
        //           child: pw.Align(
        //             alignment: pw.Alignment.centerRight,
        //             child: pw.Text(
        //               (task['status'] == "completed") ? 'Yes' : 'No',
        //               style: TextStyleManager.getTextStyle(
        //                 languageCode: languageCode,
        //                 color: contentTextColor,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        ...dateTemperatures.entries.map((entry) {
          return PdfWidgetBuilder.buildTemperatureRowWithDate(
            entry.key,
            '${entry.value.toStringAsFixed(2)}',
            languageCode,
          );
        }).toList(),
      ],
    );
  }
}

class PdfService {
  static Map<String, List<Map<String, dynamic>>> _groupTasksByDate(
      List<Map<String, dynamic>> tasks) {
    final Map<String, List<Map<String, dynamic>>> groupedTasks = {};

    for (var task in tasks) {
      final date =
          DateTime.parse(task['createdAt']).toIso8601String().substring(0, 10);
      if (!groupedTasks.containsKey(date)) {
        groupedTasks[date] = [];
      }
      groupedTasks[date]!.add(task);
    }

    // Sort tasks within each date group by taskNumber
    groupedTasks.forEach((date, tasks) {
      tasks.sort((a, b) {
        final aTaskNumber = a['taskNumber'] ?? 0;
        final bTaskNumber = b['taskNumber'] ?? 0;
        return aTaskNumber.compareTo(bTaskNumber);
      });
    });

    return groupedTasks;
  }

  static Future<pw.Document> generateReport({
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic> data,
    required String languageCode,
  }) async {
    final pdf = pw.Document();
    if (languageCode == 'zh') {
      await FontManager.getChineseFont();
    }

    // Group tasks by date for both opening and closing checklists
    final groupedOpeningTasks = _groupTasksByDate(data['openingTasks']);
    final groupedClosingTasks = _groupTasksByDate(data['closingTasks']);
    print(data['incidents']);
    // Get all unique dates
    final allDates = {...groupedOpeningTasks.keys, ...groupedClosingTasks.keys}
        .toList()
      ..sort();
    List<pw.Widget> incidentWidgets = [];
    for (var incident in data['incidents']) {
      incidentWidgets
          .add(PdfWidgetBuilder.buildIncidentRow(incident, languageCode));
    }
    // Create a list of widgets for each date
    List<pw.Widget> dateWidgets = [];
    for (var date in allDates) {
      dateWidgets.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
              style: TextStyleManager.getTextStyle(
                languageCode: languageCode,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 10),
            // Opening Checklist for the day
            if (groupedOpeningTasks.containsKey(date)) ...[
              PdfWidgetBuilder.buildHeader(
                'Opening Checklist',
                '${groupedOpeningTasks[date]!.length}',
                languageCode,
              ),
              pw.SizedBox(height: 10),
              ...groupedOpeningTasks[date]!.map((task) {
                if (task['isTemperature'] == true &&
                    task['completeat'] != null) {
                  return TemperaturePdfBuilder.buildTemperatureSection(
                    task,
                    data['sensorData'],
                    languageCode,
                  );
                } else {
                  return PdfWidgetBuilder.buildTaskRow(
                    task,
                    task['status'] == 'completed',
                    task['isSection'],
                    languageCode,
                  );
                }
              }).toList(),
              pw.SizedBox(height: 20),
            ],
            // Closing Checklist for the day
            if (groupedClosingTasks.containsKey(date)) ...[
              PdfWidgetBuilder.buildHeader(
                'Closing Checklist',
                '${groupedClosingTasks[date]!.length}',
                languageCode,
              ),
              pw.SizedBox(height: 10),
              ...groupedClosingTasks[date]!.map((task) {
                if (task['isTemperature'] == true &&
                    task['completeat'] != null) {
                  return TemperaturePdfBuilder.buildTemperatureSection(
                    task,
                    data['sensorData'],
                    languageCode,
                  );
                } else {
                  return PdfWidgetBuilder.buildTaskRow(
                    task,
                    task['status'] == 'completed',
                    false,
                    languageCode,
                  );
                }
              }).toList(),
              pw.SizedBox(height: 20),
            ],
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 20),
          ],
        ),
      );
    }

    // Split date widgets into chunks to avoid too many pages
    const int maxWidgetsPerPage = 1; // Keep at 1 widget per page
    // for (var i = 0; i < dateWidgets.length; i += maxWidgetsPerPage) {
    //   final end = (i + maxWidgetsPerPage < dateWidgets.length)
    //       ? i + maxWidgetsPerPage
    //       : dateWidgets.length;
    //   final pageWidgets = dateWidgets.sublist(i, end);

    // Split the date widget into smaller components
    // for (var widget in pageWidgets) {
    //   if (widget is pw.Column) {
    //     final children = (widget as pw.Column).children;
    //     for (var child in children) {
    pdf.addPage(
      pw.MultiPage(
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: languageCode == 'zh'
                  ? FontManager._chineseFont!
                  : FontManager.getDefaultFont(),
              bold: languageCode == 'zh'
                  ? FontManager._chineseFont!
                  : FontManager.getDefaultFont(),
            ),
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(10),
          ),
          build: (context) => dateWidgets),
    );

    // Add incidents on a separate page
    if (data['incidents'].isNotEmpty) {
      const int maxIncidentsPerPage = 10; // Reduced to 1 incident per page
      for (var i = 0; i < data['incidents'].length; i += maxIncidentsPerPage) {
        final end = (i + maxIncidentsPerPage < data['incidents'].length)
            ? i + maxIncidentsPerPage
            : data['incidents'].length;
        final pageIncidents = data['incidents'].sublist(i, end);

        pdf.addPage(
          pw.MultiPage(
            pageTheme: pw.PageTheme(
              theme: pw.ThemeData.withFont(
                base: languageCode == 'zh'
                    ? FontManager._chineseFont!
                    : FontManager.getDefaultFont(),
                bold: languageCode == 'zh'
                    ? FontManager._chineseFont!
                    : FontManager.getDefaultFont(),
              ),
              pageFormat: PdfPageFormat.a4,
            ),
            build: (context) => [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PdfWidgetBuilder.buildHeader(
                      'Incident List',
                      '${data['incidents'].length}',
                      languageCode,
                    ),
                    pw.SizedBox(height: 30),
                    ...incidentWidgets,
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    return pdf;
  }
}
