import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class WeekModel {
  final String dayOfWeek;
  final int value;
  final charts.Color color;
  WeekModel(this.dayOfWeek, this.value, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}