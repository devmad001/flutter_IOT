import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                onPressed: () {
                  // TODO: Implement download functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading report...')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Report'),
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
