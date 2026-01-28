import 'package:mm_inventory_web/bootstrap.dart';
import 'package:mm_inventory_web/ui/utils/constants/text_strings.dart';
import 'package:mm_inventory_web/app/app.router.dart';

Future<void> main() async => await bootstrap(
      () => const MainApp(),
      environment: FlavorType.local,
      appTitle: '${TTexts.appName} (Local)',
      stackedRouter: stackedRouter,
    );
