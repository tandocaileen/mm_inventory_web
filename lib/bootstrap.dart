import 'dart:async';
import 'package:mm_inventory_web/app/app.bottomsheets.dart';
import 'package:mm_inventory_web/app/app.dialogs.dart';
import 'package:mm_inventory_web/app/app.locator.custom.dart';
import 'package:mm_inventory_web/app/app.locator.dart';
import 'package:mm_inventory_web/app/app.router.dart';
import 'package:mm_inventory_web/ui/utils/constants/text_strings.dart';
import 'package:mm_inventory_web/ui/utils/device/web_material_scroll.dart';
import 'package:mm_inventory_web/ui/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_strategy/url_strategy.dart';

class FlavorType {
  static const String dev = 'dev';
  static const String prod = 'prod';
  static const String qa = 'qa';
  static const String local = 'local';
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required String environment,
  required String appTitle,
  StackedRouterWeb? stackedRouter,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await setupLocator(environment: environment, stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();
  await customSetupLocator(
    environment: environment,
    stackedRouter: stackedRouter,
  );
  runApp(await builder());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (_) => MaterialApp.router(
        title: TTexts.appName,
        themeMode: ThemeMode.light,
        darkTheme: TAppTheme.darkTheme,
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.lightTheme,
        routerDelegate: stackedRouter.delegate(),
        routeInformationParser: stackedRouter.defaultRouteParser(),
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 400),
        );
  }
}
