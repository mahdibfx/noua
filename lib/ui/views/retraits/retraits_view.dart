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

import 'retraits_viewmodel.dart';

class RetraitsView extends StackedView<RetraitsViewModel> {
  const RetraitsView({super.key});

  @override
  void onViewModelReady(RetraitsViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, RetraitsViewModel viewModel, Widget? child) {
    final retraits = viewModel.retraits;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText.titleLarge(text: 'retraits.title'.tr()),
          verticalSpaceTiny,
          CustomText.bodySmall(text: 'retraits.subtitle'.tr()),
          verticalSpace(12),
          Expanded(
            child: AsyncList(
              isBusy: viewModel.isBusy,
              isEmpty: retraits.isEmpty,
              emptyMessage: 'retraits.empty'.tr(),
              child: RefreshIndicator(
                onRefresh: viewModel.init,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: retraits.length,
                  separatorBuilder: (_, _) => verticalSpaceSmall,
                  itemBuilder: (_, i) {
                    final r = retraits[i];
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * i),
                      child: DocumentCard(
                        title: r.reference,
                        badge: StatusPill.neutral(r.date),
                        subtitles: [
                          [r.treasury, r.partner].where((e) => e.isNotEmpty).join(' · '),
                          if (r.category.isNotEmpty) r.category,
                        ],
                        footer: CustomText.bodyMedium(text: formatDa(r.amount), fontWeight: FontWeight.w600),
                        onTap: () => viewModel.onRetraitTap(r),
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
  RetraitsViewModel viewModelBuilder(BuildContext context) => RetraitsViewModel();
}
