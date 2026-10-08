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

class RetraitDetailsView extends StackedView<RetraitDetailsViewModel> {
  const RetraitDetailsView({super.key, required this.retrait});

  final Retrait retrait;

  @override
  void onViewModelReady(RetraitDetailsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, RetraitDetailsViewModel viewModel, Widget? child) {
    final r = viewModel.retrait;
    return DetailScaffold(
      title: r.reference,
      onBack: viewModel.onBack,
      badges: [StatusPill.neutral([r.date, r.time].where((e) => e.isNotEmpty).join(' · '))],
      children: [
        InfoBox(children: [
          KeyValueRow(label: 'retraits.treasury'.tr(), value: r.treasury),
          if (r.partner.isNotEmpty) KeyValueRow(label: 'retraits.partner'.tr(), value: r.partner),
          if (r.category.isNotEmpty) KeyValueRow(label: 'retraits.category'.tr(), value: r.category),
          if (r.chargeAccount.isNotEmpty)
            KeyValueRow(label: 'retraits.charge_account'.tr(), value: r.chargeAccount),
          KeyValueRow(
            label: 'retraits.imputation_account'.tr(),
            value: r.imputationAccount ?? '—',
            isLast: true,
          ),
        ]),
        if (r.designation.isNotEmpty) ...[
          SectionLabel('retraits.designation'.tr()),
          InfoBox(children: [CustomText.bodyMedium(text: r.designation, maxLines: 6)]),
        ],
        AmountBox(label: 'retraits.amount'.tr(), amount: formatDa(r.amount)),
      ],
    );
  }

  @override
  RetraitDetailsViewModel viewModelBuilder(BuildContext context) => RetraitDetailsViewModel(retrait);
}

// ponytail: read-only screen, VM kept in the same file.
class RetraitDetailsViewModel extends BaseViewModel {
  RetraitDetailsViewModel(this._retrait);

  final _managerService = locator<ManagerService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  Retrait _retrait;
  Retrait get retrait => _retrait;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchRetrait(_retrait.id);
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (detail) => _retrait = detail,
    );
  }

  void onBack() => _navigationService.back();
}
