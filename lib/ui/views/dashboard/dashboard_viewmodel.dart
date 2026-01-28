import 'package:flutter/material.dart';
import 'package:mm_inventory_web/services/inventory_service.dart';
import 'package:mm_inventory_web/ui/models/chart_data.dart';
import 'package:mm_inventory_web/ui/models/dashboard.dart';
import 'package:mm_inventory_web/ui/models/inventory.dart';
import 'package:mm_inventory_web/ui/utils/date_formatter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacked/stacked.dart';

//TODO: make generic table name and chart data provider for reuse in other viewmodels
class DashboardViewModel extends BaseViewModel {
  DashboardViewModel({
    required this.inventoryService,
  });

  final InventoryService inventoryService;

  DashboardResponse? dashboardDetails;
  DateTime selectedDate = DateTime.now();
  List<Inventory> inventoryList = [];
  final TextEditingController dateController = TextEditingController();
  DateTime? lastApiCallTime;

  Future<void> init() async {
    dateController.text = DateFormatter.formatForApi(selectedDate);
    await loadData();
  }

  Future<void> loadData() async {
    setBusy(true);
    try {
      dashboardDetails = await inventoryService.getDashboardDetails(
        date: DateFormatter.formatForApi(selectedDate),
      );
      lastApiCallTime = DateTime.now();
      // inventoryList = await inventoryService.getInventoryList();
    } catch (e) {
      // Log the error but continue with empty data
      dashboardDetails = null;
      inventoryList = [];
    } finally {
      setBusy(false);
    }
  }

  void onDateChanged(DateTime? date) {
    if (date != null) {
      selectedDate = date;
      dateController.text = DateFormatter.formatForApi(date);
      loadData();
    }
  }

  List<ChartData>? getChartData() {
    if (dashboardDetails == null) return null;

    // For stacked bar chart, we need to return data for each product
    // Each product will be a series in the stacked chart
    return dashboardDetails!.products.map((product) {
      final count = dashboardDetails!.isToday
          ? (product.currentCount ?? 0)
          : (product.endOfDayCount ?? 0);

      return ChartData(product.productName, count.toDouble());
    }).toList();
  }

  // New method for stacked bar chart data
  List<StackedColumnSeries<ChartData, String>> getStackedBarSeries() {
    if (dashboardDetails == null) return [];

    final series = <StackedColumnSeries<ChartData, String>>[];
    final productCount = dashboardDetails!.products.length;

    for (int i = 0; i < productCount; i++) {
      final product = dashboardDetails!.products[i];
      final color = _generateDistinctColor(i, productCount);

      final seriesData = [
        ChartData('Start of Day', product.startOfDayCount.toDouble()),
        ChartData(
            'Current/End of Day',
            dashboardDetails!.isToday
                ? (product.currentCount ?? 0).toDouble()
                : (product.endOfDayCount ?? 0).toDouble()),
      ];

      series.add(
        StackedColumnSeries<ChartData, String>(
          dataSource: seriesData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          name: product.productName,
          color: color,
        ),
      );
    }

    return series;
  }

  // Generate distinct colors for any number of items using HSL color space
  Color _generateDistinctColor(int index, int totalItems) {
    // Use golden angle approximation for better color distribution
    const double goldenAngle = 137.507764; // degrees
    final hue = (index * goldenAngle) % 360;

    // Keep saturation and lightness in good ranges for readability
    const saturation = 0.7; // 70% saturation
    const lightness = 0.5; // 50% lightness for good contrast

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  List<Map<String, dynamic>> getTableData() {
    if (dashboardDetails == null) return [];

    return dashboardDetails!.products.map((product) {
      final count = dashboardDetails!.isToday
          ? (product.currentCount ?? 0).toString()
          : (product.endOfDayCount ?? 0).toString();

      return {
        'SKU': product.sku,
        'Product Name': product.productName,
        'Scanned In': product.scannedIn.toString(),
        'Scanned Out': product.scannedOut.toString(),
        'Start of Day': product.startOfDayCount.toString(),
        'Current/End of Day': count,
      };
    }).toList();
  }

  String getLastApiCallTimeFormatted() {
    if (lastApiCallTime == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastApiCallTime!);

    if (difference.inMinutes < 60) {
      // Format as 12-hour time with AM/PM for recent calls
      final hour = lastApiCallTime!.hour;
      final minute = lastApiCallTime!.minute;
      final period = hour >= 12 ? 'pm' : 'am';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final minuteStr = minute.toString().padLeft(2, '0');
      return '$displayHour:$minuteStr$period';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Format as date and 12-hour time with AM/PM
      final dateStr =
          '${lastApiCallTime!.year}-${lastApiCallTime!.month.toString().padLeft(2, '0')}-${lastApiCallTime!.day.toString().padLeft(2, '0')}';
      final hour = lastApiCallTime!.hour;
      final minute = lastApiCallTime!.minute;
      final period = hour >= 12 ? 'pm' : 'am';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final minuteStr = minute.toString().padLeft(2, '0');
      return '$dateStr $displayHour:$minuteStr$period';
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
