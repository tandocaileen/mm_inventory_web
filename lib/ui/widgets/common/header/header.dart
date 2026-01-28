import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';

import 'header_model.dart';

class Header extends StackedView<HeaderModel> {
  const Header({super.key});

  @override
  Widget builder(
    BuildContext context,
    HeaderModel viewModel,
    Widget? child,
  ) {
    return AppBar(
      title: const Text(
        'MM Inventory Web',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: kcPrimaryColor,
      elevation: 1,
      centerTitle: true,
    );
  }

  @override
  HeaderModel viewModelBuilder(
    BuildContext context,
  ) =>
      HeaderModel();
}
