import 'package:easy_localization/easy_localization.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseOrdersViewModel extends BaseViewModel {
  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  List<CommandOrder> _all = [];

  int tabIndex = 0;
  bool get isPendingTab => tabIndex == 0;
  List<String> get tabLabels => ['common.pending'.tr(), 'common.history'.tr()];

  List<CommandOrder> get orders => _all.where((e) => e.isActionable == isPendingTab).toList();

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchCommandOrders();
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (orders) => _all = orders,
    );
  }

  void onTabTap(int index) {
    tabIndex = index;
    rebuildUi();
  }

  Future<void> onOrderTap(CommandOrder order) async {
    final changed = await _navigationService.navigateToPurchaseOrderDetailsView(order: order);
    if (changed == true) await init();
  }
}
