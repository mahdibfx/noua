import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RetraitsViewModel extends BaseViewModel {
  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  List<Retrait> _retraits = [];
  List<Retrait> get retraits => _retraits;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchRetraits();
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (retraits) => _retraits = retraits,
    );
  }

  void onRetraitTap(Retrait retrait) => _navigationService.navigateToRetraitDetailsView(retrait: retrait);
}
