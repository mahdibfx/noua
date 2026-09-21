import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/detail_scaffold.dart';
import 'package:noua/ui/widgets/info_box.dart';
import 'package:noua/ui/widgets/status_pill.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';

import 'purchase_request_details_viewmodel.dart';

class PurchaseRequestDetailsView extends StackedView<PurchaseRequestDetailsViewModel> {
  const PurchaseRequestDetailsView({super.key, required this.request});

  final PurchaseRequest request;

  @override
  void onViewModelReady(PurchaseRequestDetailsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PurchaseRequestDetailsViewModel viewModel, Widget? child) {
    final r = viewModel.request;
    return DetailScaffold(
      title: r.reference,
      onBack: viewModel.onBack,
      badges: [
        if (r.priority > 0) StatusPill.priority(r.priority, long: true),
        StatusPill.status(r.status, apiLabel: r.statusLabel),
      ],
      bottom: viewModel.isPending
          ? ValidationActions(
              onValidate: viewModel.onValidateTap,
              onRefuse: viewModel.onRefuseTap,
              isBusy: viewModel.isBusy,
            )
          : null,
      children: [
        InfoBox(children: [
          KeyValueRow(label: 'purchase_requests.requester'.tr(), value: r.requester),
          KeyValueRow(label: 'purchase_requests.site'.tr(), value: r.site),
          KeyValueRow(label: 'purchase_requests.type'.tr(), value: r.type),
          if (r.beb != null) KeyValueRow(label: 'purchase_requests.beb'.tr(), value: r.beb!),
          KeyValueRow(label: 'common.date'.tr(), value: r.date),
          KeyValueRow(label: 'common.created_by'.tr(), value: r.createdBy, isLast: true),
        ]),
        SectionLabel('purchase_requests.items_title'.tr()),
        if (viewModel.isBusy && r.products.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ))
        else if (r.products.isEmpty)
          InfoBox(children: [CustomText.bodySmall(text: 'common.empty_list'.tr())])
        else
          for (final item in r.products)
            InfoBox(children: [
              CustomText.bodyMedium(text: item.name, fontWeight: FontWeight.w600, maxLines: 2),
              const SizedBox(height: 8),
              QuantityGrid(entries: [
                ('purchase_requests.requested'.tr(), formatQty(item.quantity, item.unit)),
                ('purchase_requests.ordered'.tr(), formatQty(item.processed, item.unit)),
                ('purchase_requests.remaining'.tr(), formatQty(item.remaining, item.unit)),
              ]),
              if (item.neededAt != null) ...[
                const Divider(height: 20, color: AppColors.borderColor),
                KeyValueRow(label: 'purchase_requests.needed_at'.tr(), value: item.neededAt!, isLast: true),
              ],
            ]),
      ],
    );
  }

  @override
  PurchaseRequestDetailsViewModel viewModelBuilder(BuildContext context) =>
      PurchaseRequestDetailsViewModel(request);
}
