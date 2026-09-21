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

import 'purchase_order_details_viewmodel.dart';

class PurchaseOrderDetailsView extends StackedView<PurchaseOrderDetailsViewModel> {
  const PurchaseOrderDetailsView({super.key, required this.order});

  final CommandOrder order;

  @override
  void onViewModelReady(PurchaseOrderDetailsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PurchaseOrderDetailsViewModel viewModel, Widget? child) {
    final o = viewModel.order;
    return DetailScaffold(
      title: o.reference,
      onBack: viewModel.onBack,
      badges: [StatusPill.status(o.status, apiLabel: o.statusLabel)],
      bottom: viewModel.isPending
          ? ValidationActions(
              onValidate: viewModel.onValidateTap,
              onRefuse: viewModel.onRefuseTap,
              isBusy: viewModel.isBusy,
            )
          : null,
      children: [
        InfoBox(children: [
          KeyValueRow(label: 'purchase_orders.supplier'.tr(), value: o.supplier),
          if (o.service.isNotEmpty) KeyValueRow(label: 'purchase_orders.service'.tr(), value: o.service),
          if (o.paymentMode.isNotEmpty)
            KeyValueRow(label: 'purchase_orders.payment_mode'.tr(), value: o.paymentMode),
          if (o.deliveryDate.isNotEmpty)
            KeyValueRow(label: 'purchase_orders.delivery_date'.tr(), value: o.deliveryDate),
          KeyValueRow(label: 'common.date'.tr(), value: o.date),
          KeyValueRow(label: 'common.created_by'.tr(), value: o.createdBy, isLast: true),
        ]),
        SectionLabel('purchase_orders.items_title'.tr()),
        if (viewModel.isBusy && o.products.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ))
        else if (o.products.isEmpty)
          InfoBox(children: [CustomText.bodySmall(text: 'common.empty_list'.tr())])
        else
          for (final item in o.products)
            InfoBox(children: [
              CustomText.bodyMedium(text: item.name, fontWeight: FontWeight.w600, maxLines: 2),
              const SizedBox(height: 8),
              QuantityGrid(entries: [
                ('purchase_orders.ordered'.tr(), formatQty(item.quantity, item.unit)),
                ('purchase_orders.delivered'.tr(), formatQty(item.processed, item.unit)),
                ('purchase_orders.remaining'.tr(), formatQty(item.remaining, item.unit)),
              ]),
              if (item.unitPrice > 0) ...[
                const Divider(height: 20, color: AppColors.borderColor),
                KeyValueRow(
                  label: 'purchase_orders.unit_price'.tr(),
                  value: formatDa(item.unitPrice),
                  isLast: true,
                ),
              ],
            ]),
        AmountBox(label: 'purchase_orders.total_ttc'.tr(), amount: formatDa(o.totalTtc)),
      ],
    );
  }

  @override
  PurchaseOrderDetailsViewModel viewModelBuilder(BuildContext context) => PurchaseOrderDetailsViewModel(order);
}
