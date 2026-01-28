import 'package:mm_inventory_web/bootstrap.dart';
import 'package:mm_inventory_web/ui/utils/constants/text_strings.dart';

Future<void> main() async => await bootstrap(
      () => const MainApp(),
      environment: FlavorType.qa,
      appTitle: '${TTexts.appName} (QA)',
    );
