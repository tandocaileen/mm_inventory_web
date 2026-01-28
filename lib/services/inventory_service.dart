import 'dart:developer';

import 'package:mm_inventory_web/app/app.locator.dart';
import 'package:mm_inventory_web/services/inventory_client.dart';
import 'package:mm_inventory_web/ui/models/inventory.dart';
import 'package:injectable/injectable.dart';
import 'package:mm_inventory_web/ui/models/dashboard.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_snackbar/custom_snackbar.dart';

@LazySingleton()
class InventoryService {
  InventoryService({
    InventoryClient? inventoryClient,
  }) : _client = inventoryClient ?? locator<InventoryClient>();

  final InventoryClient _client;

  // Get dashboard details for a specific date
  Future<DashboardResponse> getDashboardDetails({String? date}) async {
    final effectiveDate = date ?? DateTime.now().toIso8601String();
    try {
      return await _client.getDashboardDetails(effectiveDate);
      // return SkuCount.sampleSkuCountData();
    } catch (e) {
      log(e.toString());
      showErrorSnackbar('Failed to fetch dashboard details');
      throw Exception('Failed to fetch dashboard details');
    }
  }

  // Get inventory list
  Future<List<Inventory>> getInventoryList() async {
    try {
      return await _client.getInventoryList();
      // return Inventory.sampleInventoryData();
    } catch (e) {
      log(e.toString());
      showErrorSnackbar('Failed to fetch inventory list');
      throw Exception('Failed to fetch inventory list');
    }
  }
}
