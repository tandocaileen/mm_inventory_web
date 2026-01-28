import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:mm_inventory_web/ui/widgets/common/footer/footer.dart';
import 'package:mm_inventory_web/ui/widgets/common/header/header.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({
    super.key,
    this.body,
    GlobalKey<ScaffoldState>? scaffoldKey,
    this.isLoading = false,
    this.isScrollable = true,
  }) : scaffoldKey = scaffoldKey ?? GlobalKey<ScaffoldState>();

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isLoading;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcWhiteColor,
      key: scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isScrollable
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        body ?? const SizedBox(),
                        const Footer(),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      body ?? const SizedBox(),
                      const Footer(),
                    ],
                  ),
      ),
    );
  }
}
