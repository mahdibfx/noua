import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/common/ui_helpers.dart';
import 'package:noua/ui/widgets/custom_button.dart';
import 'package:noua/ui/widgets/custom_input.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/fade_in_up.dart';
import 'package:noua/ui/widgets/segmented_tabs.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import 'widgets/balance_card.dart';
import 'widgets/metric_tile.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final stats = viewModel.stats;
    return RefreshIndicator(
      onRefresh: viewModel.init,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 16),
        child: FadeInUp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText.titleLarge(text: 'dashboard.title'.tr()),
              verticalSpace(12),
              SegmentedTabs(
                labels: viewModel.periodLabels,
                selectedIndex: viewModel.periodIndex,
                onChanged: viewModel.onPeriodTap,
              ),
              verticalSpace(8),
              Row(
                children: [
                  Expanded(child: CustomInput(controller: viewModel.fromController, onTap: viewModel.onFromTap)),
                  horizontalSpaceSmall,
                  Expanded(child: CustomInput(controller: viewModel.toController, onTap: viewModel.onToTap)),
                ],
              ),
              verticalSpace(14),
              if (viewModel.isBusy && stats == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                )
              else if (stats == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: CustomButton.outlined(
                      onPressed: viewModel.init,
                      text: 'common.retry'.tr(),
                      expanded: false,
                    ),
                  ),
                )
              else ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: MetricTile(label: 'dashboard.revenue'.tr(), value: formatDa(stats.revenue, round: true))),
                      const SizedBox(width: 8),
                      Expanded(child: MetricTile(label: 'dashboard.collections'.tr(), value: formatDa(stats.collections, round: true))),
                    ],
                  ),
                ),
                verticalSpace(8),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: MetricTile(label: 'dashboard.purchases'.tr(), value: formatDa(stats.purchases, round: true))),
                      const SizedBox(width: 8),
                      Expanded(child: MetricTile(label: 'dashboard.supplier_payments'.tr(), value: formatDa(stats.supplierPayments, round: true))),
                    ],
                  ),
                ),
                verticalSpace(8),
                MetricTile(label: 'dashboard.withdrawals'.tr(), value: formatDa(stats.withdrawals, round: true)),
                verticalSpace(8),
                BalanceCard(
                  label: 'dashboard.customers_balance'.tr(),
                  value: formatDa(stats.customersBalance, round: true),
                  color: AppColors.redColor,
                  background: AppColors.redColorLight,
                ),
                verticalSpace(8),
                BalanceCard(
                  label: 'dashboard.suppliers_balance'.tr(),
                  value: formatDa(stats.suppliersBalance, round: true),
                  color: AppColors.orangeColor,
                  background: AppColors.orangeColorLight,
                ),
                verticalSpace(18),
                CustomText.bodySmall(text: 'dashboard.pending_validation'.tr()),
                verticalSpace(8),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton.outlined(
                        onPressed: viewModel.onPendingPurchasesTap,
                        text: 'dashboard.pending_purchases'.plural(stats.pendingPurchaseRequests),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: CustomButton.outlined(
                        onPressed: viewModel.onPendingOrdersTap,
                        text: 'dashboard.pending_orders'.plural(stats.pendingOrders),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel(onOpenTab);
}
