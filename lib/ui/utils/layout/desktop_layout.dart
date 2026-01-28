import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:mm_inventory_web/ui/widgets/common/footer/footer.dart';
import 'package:mm_inventory_web/ui/widgets/common/header/header.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    this.body,
    this.scaffoldKey,
    this.endDrawer,
    this.isLoading = false,
    this.isScrollable = true,
  });

  final Widget? body;
  final Widget? endDrawer;
  final Key? scaffoldKey;
  final bool isLoading;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcWhiteColor,
      key: scaffoldKey,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isScrollable
                    ? SingleChildScrollView(child: body ?? const SizedBox())
                    : body ?? const SizedBox(),
          ),
          const Footer(),
        ],
      ),
      endDrawer: endDrawer,
    );
  }
}
