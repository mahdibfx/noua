import 'package:easy_localization/easy_localization.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseRequestsViewModel extends BaseViewModel {
  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  // ponytail: one unfiltered fetch, the two tabs split it locally — the API's
  // status filter only covers the pending states, never the history ones.
  List<PurchaseRequest> _all = [];

  int tabIndex = 0;
  bool get isPendingTab => tabIndex == 0;
  List<String> get tabLabels => ['common.pending'.tr(), 'common.history'.tr()];

  List<PurchaseRequest> get requests =>
      _all.where((e) => e.status.isPending == isPendingTab).toList();

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchPurchaseRequests();
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (requests) => _all = requests,
    );
  }

  void onTabTap(int index) {
    tabIndex = index;
    rebuildUi();
  }

  Future<void> onRequestTap(PurchaseRequest request) async {
    final changed = await _navigationService.navigateToPurchaseRequestDetailsView(request: request);
    if (changed == true) await init();
  }
}
