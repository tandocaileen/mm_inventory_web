import 'package:flutter/material.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:mm_inventory_web/ui/common/ui_helpers.dart';
import 'package:mm_inventory_web/ui/utils/layout/mobile_layout.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_field/custom_field.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_table/custom_table.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashboardViewMobile extends ViewModelWidget<DashboardViewModel> {
  const DashboardViewMobile({super.key});

  @override
  Widget build(BuildContext context, DashboardViewModel viewModel) {
    return _DashboardViewMobileContent(viewModel: viewModel);
  }
}

class _DashboardViewMobileContent extends StatefulWidget {
  const _DashboardViewMobileContent({required this.viewModel});

  final DashboardViewModel viewModel;

  @override
  State<_DashboardViewMobileContent> createState() =>
      _DashboardViewMobileContentState();
}

class _DashboardViewMobileContentState
    extends State<_DashboardViewMobileContent> {
  bool _showLegend = true;

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      isLoading: widget.viewModel.isBusy,
      isScrollable: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Inventory for ${widget.viewModel.selectedDate.toLocal().toString().split(' ')[0]} (Last updated: ${widget.viewModel.getLastApiCallTimeFormatted()})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kcPrimaryColor,
                  ),
            ),
            verticalSpace(16.0),

            // Date Picker
            Row(
              children: [
                Expanded(
                  child: CustomField(
                    label: 'Select Date',
                    formType: FormType.datetime,
                    controller: widget.viewModel.dateController,
                    initialDate: widget.viewModel.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    onDateTimeChanged: widget.viewModel.onDateChanged,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _showLegend = !_showLegend),
                  icon: Icon(
                      _showLegend ? Icons.visibility_off : Icons.visibility),
                  tooltip: _showLegend ? 'Hide Legend' : 'Show Legend',
                  iconSize: 20,
                  color: kcMediumGrey,
                ),
              ],
            ),
            verticalSpace(16.0),

            // Pie Chart
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Inventory',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    verticalSpace(16.0),
                    SizedBox(
                      height: 200,
                      child: Builder(
                        builder: (context) {
                          final chartData = widget.viewModel.getChartData();
                          final hasData = chartData != null &&
                              chartData.isNotEmpty &&
                              chartData.any((data) => data.value > 0);

                          if (!hasData) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.inventory_2_outlined,
                                      size: 48, color: kcMediumGrey),
                                  verticalSpaceSmall,
                                  Text(
                                    'Empty inventory for the selected date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: kcMediumGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return SfCartesianChart(
                            primaryXAxis: const CategoryAxis(
                              labelRotation: 0,
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                            ),
                            series: widget.viewModel.getStackedBarSeries(),
                            legend: Legend(
                              isVisible: _showLegend,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            tooltipBehavior: TooltipBehavior(enable: true),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(16.0),

            // Products Table
            Flexible(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Products',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            onPressed: widget.viewModel.loadData,
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Reload Data',
                            color: kcPrimaryColor,
                          ),
                        ],
                      ),
                      verticalSpace(16.0),
                      Expanded(
                        child: CustomTable(
                          data: widget.viewModel.getTableData(),
                          columns: const [
                            'SKU',
                            'Product Name',
                            'Start of Day',
                            'Current/End of Day',
                          ],
                          shrinkWrapRows: false,
                          expandToFillSpace: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
