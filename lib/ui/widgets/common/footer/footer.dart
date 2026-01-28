import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';

import 'footer_model.dart';

class Footer extends StackedView<FooterModel> {
  const Footer({super.key});

  @override
  Widget builder(
    BuildContext context,
    FooterModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.grey[100],
      child: const Center(
        child: Text(
          '© 2026 MM Inventory Web - All rights reserved',
          style: TextStyle(
            color: kcMediumGrey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  FooterModel viewModelBuilder(
    BuildContext context,
  ) =>
      FooterModel();
}
