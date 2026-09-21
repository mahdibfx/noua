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
import 'package:stacked/stacked.dart';

import 'purchase_requests_viewmodel.dart';

class PurchaseRequestsView extends StackedView<PurchaseRequestsViewModel> {
  const PurchaseRequestsView({super.key});

  @override
  void onViewModelReady(PurchaseRequestsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PurchaseRequestsViewModel viewModel, Widget? child) {
    final requests = viewModel.requests;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText.titleLarge(text: 'purchase_requests.title'.tr()),
          verticalSpace(12),
          SegmentedTabs(labels: viewModel.tabLabels, selectedIndex: viewModel.tabIndex, onChanged: viewModel.onTabTap),
          verticalSpace(12),
          Expanded(
            child: AsyncList(
              isBusy: viewModel.isBusy,
              isEmpty: requests.isEmpty,
              emptyMessage: (viewModel.isPendingTab ? 'common.empty_pending' : 'common.empty_history').tr(),
              child: RefreshIndicator(
                onRefresh: viewModel.init,
                child: ListView.separated(
                  key: ValueKey('list${viewModel.tabIndex}'),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: requests.length,
                  separatorBuilder: (_, _) => verticalSpaceSmall,
                  itemBuilder: (_, i) {
                    final r = requests[i];
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * i),
                      child: DocumentCard(
                        title: r.reference,
                        badge: StatusPill.status(r.status, apiLabel: r.statusLabel),
                        subtitles: [
                          [r.type, r.requester].where((e) => e.isNotEmpty).join(' · '),
                          [r.site, r.date].where((e) => e.isNotEmpty).join(' · '),
                        ],
                        footer: r.priority > 0 ? StatusPill.priority(r.priority) : null,
                        onTap: () => viewModel.onRequestTap(r),
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
  PurchaseRequestsViewModel viewModelBuilder(BuildContext context) => PurchaseRequestsViewModel();
}
