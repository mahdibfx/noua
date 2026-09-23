import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:noua/utils/document_decision.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseOrderDetailsViewModel extends BaseViewModel with DocumentDecision {
  PurchaseOrderDetailsViewModel(this._order);

  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  CommandOrder _order;
  CommandOrder get order => _order;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchCommandOrder(_order.id);
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (detail) => _order = detail,
    );
  }

  @override
  String get documentReference => _order.reference;

  @override
  Future<Either<Failure, Unit>> sendDecision(String action) =>
      _managerService.setCommandOrderStatus(_order.id, action: action);

  @override
  void applyStatus(DocStatus status) => _order
    ..status = status
    ..statusLabel = '';

  void onBack() => _navigationService.back();
}
