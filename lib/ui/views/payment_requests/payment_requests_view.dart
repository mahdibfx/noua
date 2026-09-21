import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/common/ui_helpers.dart';
import 'package:noua/ui/widgets/async_list.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/document_card.dart';
import 'package:noua/ui/widgets/fade_in_up.dart';
import 'package:noua/ui/widgets/status_pill.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';

import 'payment_requests_viewmodel.dart';

class PaymentRequestsView extends StackedView<PaymentRequestsViewModel> {
  const PaymentRequestsView({super.key});

  @override
  void onViewModelReady(PaymentRequestsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, PaymentRequestsViewModel viewModel, Widget? child) {
    final payments = viewModel.payments;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText.titleLarge(text: 'payment_requests.title'.tr()),
          verticalSpaceTiny,
          CustomText.bodySmall(text: 'payment_requests.subtitle'.tr()),
          verticalSpace(12),
          Expanded(
            child: AsyncList(
              isBusy: viewModel.isBusy,
              isEmpty: payments.isEmpty,
              emptyMessage: 'payment_requests.empty'.tr(),
              child: RefreshIndicator(
                onRefresh: viewModel.init,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: payments.length,
                  separatorBuilder: (_, _) => verticalSpaceSmall,
                  itemBuilder: (_, i) {
                    final p = payments[i];
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * i),
                      child: DocumentCard(
                        title: p.reference,
                        badge: StatusPill.status(p.status, apiLabel: p.statusLabel),
                        subtitles: [[p.supplier, p.date].where((e) => e.isNotEmpty).join(' · ')],
                        footer: p.amount == 0
                            ? null
                            : CustomText.bodyMedium(text: formatDa(p.amount), fontWeight: FontWeight.w600),
                        onTap: () => viewModel.onPaymentTap(p),
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
  PaymentRequestsViewModel viewModelBuilder(BuildContext context) => PaymentRequestsViewModel();
}
