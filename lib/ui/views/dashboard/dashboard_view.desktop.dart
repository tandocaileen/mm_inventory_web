import 'package:flutter/material.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:mm_inventory_web/ui/common/ui_helpers.dart';
import 'package:mm_inventory_web/ui/utils/layout/desktop_layout.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_field/custom_field.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_table/custom_table.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashboardViewDesktop extends ViewModelWidget<DashboardViewModel> {
  const DashboardViewDesktop({super.key});

  @override
  Widget build(BuildContext context, DashboardViewModel viewModel) {
    return _DashboardViewDesktopContent(viewModel: viewModel);
  }
}

class _DashboardViewDesktopContent extends StatefulWidget {
  const _DashboardViewDesktopContent({required this.viewModel});

  final DashboardViewModel viewModel;

  @override
  State<_DashboardViewDesktopContent> createState() =>
      _DashboardViewDesktopContentState();
}

class _DashboardViewDesktopContentState
    extends State<_DashboardViewDesktopContent> {
  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      isLoading: widget.viewModel.isBusy,
      isScrollable: false,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Inventory for ${widget.viewModel.selectedDate.toLocal().toString().split(' ')[0]} (Last updated: ${widget.viewModel.getLastApiCallTimeFormatted()})',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kcPrimaryColor,
                        ),
                  ),
                ),
                horizontalSpaceSmall,
                SizedBox(
                  width: 500,
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
              ],
            ),
            horizontalSpaceMedium,

            // Pie Charts and Table Row
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pie Charts Column
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Start of Day Pie Chart
                        Expanded(
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
                                        'Start of Day Inventory',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  verticalSpace(16.0),
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        final series = widget.viewModel
                                            .getStartOfDayPieSeries();
                                        final hasData = series.isNotEmpty &&
                                            series
                                                .first.dataSource!.isNotEmpty &&
                                            series.first.dataSource!
                                                .any((data) => data.value > 0);

                                        if (!hasData) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 48,
                                                    color: kcMediumGrey),
                                                verticalSpaceSmall,
                                                Text(
                                                  'No start of day inventory',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: kcMediumGrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return SfCircularChart(
                                          series: series,
                                          legend: const Legend(
                                            isVisible: false,
                                            position: LegendPosition.bottom,
                                            overflowMode:
                                                LegendItemOverflowMode.wrap,
                                          ),
                                          tooltipBehavior:
                                              TooltipBehavior(enable: true),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        verticalSpaceMedium,
                        // Current/End of Day Pie Chart
                        Expanded(
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.viewModel.dashboardDetails
                                                ?.isToday ==
                                            true
                                        ? 'Current Inventory'
                                        : 'End of Day Inventory',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  verticalSpace(16.0),
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        final series = widget.viewModel
                                            .getCurrentEndOfDayPieSeries();
                                        final hasData = series.isNotEmpty &&
                                            series
                                                .first.dataSource!.isNotEmpty &&
                                            series.first.dataSource!
                                                .any((data) => data.value > 0);

                                        if (!hasData) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 48,
                                                    color: kcMediumGrey),
                                                verticalSpaceSmall,
                                                Text(
                                                  widget
                                                              .viewModel
                                                              .dashboardDetails
                                                              ?.isToday ==
                                                          true
                                                      ? 'No current inventory'
                                                      : 'No end of day inventory',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: kcMediumGrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return SfCircularChart(
                                          series: series,
                                          legend: const Legend(
                                            isVisible: false,
                                            position: LegendPosition.bottom,
                                            overflowMode:
                                                LegendItemOverflowMode.wrap,
                                          ),
                                          tooltipBehavior:
                                              TooltipBehavior(enable: true),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpaceMedium,

                  // Products Table
                  Expanded(
                    flex: 2,
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
                                rowsPerPage: 1000,
                                data: widget.viewModel.getTableData(),
                                columns: const [
                                  'SKU',
                                  'Product Name',
                                  'Start of Day',
                                  'Current/End of Day',
                                  'Scanned In',
                                  'Scanned Out',
                                ],
                                shrinkWrapRows: false,
                                expandToFillSpace: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
