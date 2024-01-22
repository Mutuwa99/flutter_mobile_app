import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalogWatchChart extends StatelessWidget {
  final Color color;
  final int value;

  AnalogWatchChart({required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: color,
            value: value.toDouble(),
            title: value.toString(),
            radius: 40,
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        startDegreeOffset: -90,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
