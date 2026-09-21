import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/detail_scaffold.dart';
import 'package:noua/ui/widgets/info_box.dart';
import 'package:noua/ui/widgets/status_pill.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentRequestDetailsView extends StackedView<PaymentRequestDetailsViewModel> {
  const PaymentRequestDetailsView({super.key, required this.payment});

  final PaymentRequest payment;

  @override
  void onViewModelReady(PaymentRequestDetailsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PaymentRequestDetailsViewModel viewModel, Widget? child) {
    final p = viewModel.payment;
    return DetailScaffold(
      title: p.reference,
      onBack: viewModel.onBack,
      badges: [StatusPill.status(p.status, apiLabel: p.statusLabel)],
      children: [
        InfoBox(children: [
          KeyValueRow(label: 'payment_requests.supplier'.tr(), value: p.supplier),
          KeyValueRow(label: 'common.date'.tr(), value: p.date),
          if (p.observation.isNotEmpty)
            KeyValueRow(label: 'payment_requests.observation'.tr(), value: p.observation),
          KeyValueRow(label: 'common.created_by'.tr(), value: p.createdBy, isLast: true),
        ]),
        if (p.operations.isNotEmpty) ...[
          SectionLabel('payment_requests.operations'.tr()),
          for (final operation in p.operations)
            InfoBox(children: [
              CustomText.bodyMedium(text: operation.reference, fontWeight: FontWeight.w600, maxLines: 2),
              const SizedBox(height: 8),
              if (operation.type.isNotEmpty)
                KeyValueRow(label: 'payment_requests.type'.tr(), value: operation.type),
              if (operation.invoice.isNotEmpty)
                KeyValueRow(label: 'payment_requests.invoice_number'.tr(), value: operation.invoice),
              KeyValueRow(
                label: 'payment_requests.mode'.tr(),
                value: operation.mode,
                isLast: operation.amount == 0,
              ),
              if (operation.amount > 0)
                KeyValueRow(
                  label: 'payment_requests.total_amount'.tr(),
                  value: formatDa(operation.amount),
                  isLast: true,
                ),
            ]),
        ],
        AmountBox(label: 'payment_requests.total_amount'.tr(), amount: formatDa(p.amount)),
      ],
    );
  }

  @override
  PaymentRequestDetailsViewModel viewModelBuilder(BuildContext context) =>
      PaymentRequestDetailsViewModel(payment);
}

// ponytail: read-only screen, VM kept in the same file.
class PaymentRequestDetailsViewModel extends BaseViewModel {
  PaymentRequestDetailsViewModel(this._payment);

  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  PaymentRequest _payment;
  PaymentRequest get payment => _payment;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchPaymentRequest(_payment.id);
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (detail) => _payment = detail,
    );
  }

  void onBack() => _navigationService.back();
}
