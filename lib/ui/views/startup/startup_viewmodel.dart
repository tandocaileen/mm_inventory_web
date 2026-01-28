import 'package:stacked/stacked.dart';
import 'package:mm_inventory_web/app/app.router.dart';

class StartupViewModel extends BaseViewModel {
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 2));
    stackedRouter.replace(const DashboardViewRoute());
  }
}
