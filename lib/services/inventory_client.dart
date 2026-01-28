import 'package:mm_inventory_web/ui/models/inventory.dart';
import 'package:mm_inventory_web/ui/models/dashboard.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'inventory_client.g.dart';

@RestApi(baseUrl: 'https://your-api-base-url/api')
abstract class InventoryClient {
  factory InventoryClient(Dio dio, {String baseUrl}) = _InventoryClient;

  @GET('functions/v1/summary')
  Future<DashboardResponse> getDashboardDetails(
    @Query('date') String date,
  );

  @GET('rest/v1/inventory')
  Future<List<Inventory>> getInventoryList();
}
