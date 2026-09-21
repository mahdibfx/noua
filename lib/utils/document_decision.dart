import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// Valider / Refuser flow shared by the demande d'achat and bon de commande
/// detail screens. "Refuser" is the API's `cancel` action (status 3, Annulée).
mixin DocumentDecision on BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  String get documentReference;

  /// POSTs the action to the module's status endpoint.
  Future<Either<Failure, Unit>> sendDecision(String action);

  /// Applies the new status to the in-memory document.
  void applyStatus(DocStatus status);

  Future<void> onValidateTap() => _decide('validate');
  Future<void> onRefuseTap() => _decide('cancel');

  Future<void> _decide(String action) async {
    if (isBusy) return;
    final key = action == 'validate' ? 'validate' : 'refuse';
    final response = await _dialogService.showConfirmationDialog(
      title: 'validation.${key}_title'.tr(args: [documentReference]),
      description: 'validation.${key}_description'.tr(),
      confirmationTitle: 'common.$key'.tr(),
      cancelTitle: 'common.cancel'.tr(),
    );
    if (response?.confirmed != true) return;

    setBusy(true);
    final result = await sendDecision(action);
    setBusy(false);

    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (_) {
        applyStatus(action == 'validate' ? DocStatus.validee : DocStatus.annulee);
        _navigationService.back(result: true);
        _snackbarService.showSnackbar(
          message: 'validation.${action == 'validate' ? 'validated' : 'refused'}'.tr(args: [documentReference]),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}
