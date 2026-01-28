import 'dart:ui';

class ChartData {
  ChartData(this.category, this.value, {this.color});
  final String category;
  final double value;
  final Color? color;
}
