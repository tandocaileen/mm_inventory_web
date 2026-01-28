import 'package:flutter/material.dart';
import 'package:mm_inventory_web/app/app.locator.dart';
import 'package:mm_inventory_web/services/inventory_service.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_view.desktop.dart';
import 'dashboard_view.tablet.dart';
import 'dashboard_view.mobile.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const DashboardViewMobile(),
      tablet: (_) => const DashboardViewTablet(),
      desktop: (_) => const DashboardViewDesktop(),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel(inventoryService: locator<InventoryService>());

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
