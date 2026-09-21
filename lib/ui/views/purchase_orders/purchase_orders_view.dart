import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/common/ui_helpers.dart';
import 'package:noua/ui/widgets/async_list.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/document_card.dart';
import 'package:noua/ui/widgets/fade_in_up.dart';
import 'package:noua/ui/widgets/segmented_tabs.dart';
import 'package:noua/ui/widgets/status_pill.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';

import 'purchase_orders_viewmodel.dart';

class PurchaseOrdersView extends StackedView<PurchaseOrdersViewModel> {
  const PurchaseOrdersView({super.key});

  @override
  void onViewModelReady(PurchaseOrdersViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PurchaseOrdersViewModel viewModel, Widget? child) {
    final orders = viewModel.orders;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText.titleLarge(text: 'purchase_orders.title'.tr()),
          verticalSpace(12),
          SegmentedTabs(labels: viewModel.tabLabels, selectedIndex: viewModel.tabIndex, onChanged: viewModel.onTabTap),
          verticalSpace(12),
          Expanded(
            child: AsyncList(
              isBusy: viewModel.isBusy,
              isEmpty: orders.isEmpty,
              emptyMessage: (viewModel.isPendingTab ? 'common.empty_pending' : 'common.empty_history').tr(),
              child: RefreshIndicator(
                onRefresh: viewModel.init,
                child: ListView.separated(
                  key: ValueKey('list${viewModel.tabIndex}'),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => verticalSpaceSmall,
                  itemBuilder: (_, i) {
                    final o = orders[i];
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * i),
                      child: DocumentCard(
                        title: o.reference,
                        badge: StatusPill.status(o.status, apiLabel: o.statusLabel),
                        subtitles: [
                          o.supplier,
                          [o.service, o.site, o.date].where((e) => e.isNotEmpty).join(' · '),
                        ],
                        footer: o.totalTtc == 0
                            ? null
                            : CustomText.bodyMedium(
                                text: 'purchase_orders.ttc'.tr(args: [formatDa(o.totalTtc)]),
                                fontWeight: FontWeight.w600,
                              ),
                        onTap: () => viewModel.onOrderTap(o),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  PurchaseOrdersViewModel viewModelBuilder(BuildContext context) => PurchaseOrdersViewModel();
}
