import 'package:flutter_test/flutter_test.dart';
import 'package:mm_inventory_web/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('InventoryServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
