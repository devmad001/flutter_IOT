import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metrics_provider.dart';

class MetricsSelector extends StatelessWidget {
  const MetricsSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MetricsProvider>(
      builder: (context, metricsProvider, child) {
        return DropdownButton<String>(
          value: metricsProvider.unit,
          onChanged: (String? newValue) {
            if (newValue != null) {
              metricsProvider.setUnit(newValue);
            }
          },
          items: <String>['CELSIUS', 'FAHRENHEIT']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}
