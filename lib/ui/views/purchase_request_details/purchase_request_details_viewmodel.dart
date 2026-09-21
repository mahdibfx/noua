import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:noua/utils/document_decision.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseRequestDetailsViewModel extends BaseViewModel with DocumentDecision {
  PurchaseRequestDetailsViewModel(this._request);

  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  PurchaseRequest _request;
  PurchaseRequest get request => _request;

  bool get isPending => _request.status.isPending;

  /// The list payload has no product rows — the detail endpoint does.
  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchPurchaseRequest(_request.id);
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      // The detail endpoint returns the raw header status (almost always 1,
      // "En cours") while the list returns the effective one (7 En traitement,
      // 8 Commandée…). Keep the list's status so the screen matches the list and
      // Valider/Refuser don't show on DAs already being processed.
      // ponytail: drop once backend aligns the detail status (BACKEND_QUESTIONS #0).
      (detail) => _request = detail
        ..status = _request.status
        ..statusLabel = _request.statusLabel,
    );
  }

  @override
  String get documentReference => _request.reference;

  @override
  Future<Either<Failure, Unit>> sendDecision(String action) =>
      _managerService.setPurchaseRequestStatus(_request.id, action: action);

  @override
  void applyStatus(DocStatus status) => _request
    ..status = status
    ..statusLabel = '';

  void onBack() => _navigationService.back();
}
