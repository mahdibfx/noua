import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentRequestsViewModel extends BaseViewModel {
  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  List<PaymentRequest> _payments = [];
  List<PaymentRequest> get payments => _payments;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchPaymentRequests();
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (payments) => _payments = payments,
    );
  }

  void onPaymentTap(PaymentRequest payment) =>
      _navigationService.navigateToPaymentRequestDetailsView(payment: payment);
}
