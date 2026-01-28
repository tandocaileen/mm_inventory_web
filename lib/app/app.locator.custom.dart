import 'package:mm_inventory_web/app/app.locator.dart';
import 'package:mm_inventory_web/app/app.router.dart';
import 'package:mm_inventory_web/bootstrap.dart';
import 'package:mm_inventory_web/services/inventory_client.dart';
import 'package:dio/dio.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_snackbar/custom_snackbar.dart';

//TODO: put this in env file later
const String apiBaseUrl = 'https://jpboyzcnaxdpfizzbfni.supabase.co/';
const String apiKey = 'sb_publishable_Gstm22wh0AVhqhYj7G8H3w_zsYTM3WO';
Future<void> customSetupLocator({
  required String environment,
  required StackedRouterWeb? stackedRouter,
}) async {
  // Setup Dio
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: 120000,
      headers: {
        'Content-Type': 'application/json',
        // 'apikey': apiKey,
      },
    ),
  );
  if (environment != FlavorType.prod) {
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ),
    );
  }
  setupSnackbarUi();
  //setup services
  locator.registerLazySingleton(() => dio);
  locator
      .registerLazySingleton(() => InventoryClient(dio, baseUrl: apiBaseUrl));
}
