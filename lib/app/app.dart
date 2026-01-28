import 'package:mm_inventory_web/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:mm_inventory_web/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:mm_inventory_web/ui/views/home/home_view.dart';
import 'package:mm_inventory_web/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mm_inventory_web/services/inventory_service.dart';
import 'package:mm_inventory_web/ui/views/dashboard/dashboard_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    CustomRoute(page: HomeView),
    CustomRoute(page: StartupView, initial: true),
    CustomRoute(page: DashboardView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: RouterService),
    LazySingleton(classType: InventoryService),
    LazySingleton(classType: SnackbarService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
