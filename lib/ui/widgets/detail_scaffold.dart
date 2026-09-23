import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_button.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/fade_in_up.dart';

/// Shared layout of the three detail screens: "‹ Retour", title, badges, content, optional bottom actions.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    super.key,
    required this.title,
    required this.badges,
    required this.children,
    required this.onBack,
    this.bottom,
  });

  final String title;
  final List<Widget> badges;
  final List<Widget> children;
  final VoidCallback onBack;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, AppStyles.screenPadding, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.chevron_left, color: AppColors.primaryColor),
                  label: CustomText.bodyMedium(text: 'common.back'.tr(), textColor: AppColors.primaryColor),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 4, AppStyles.screenPadding, 24),
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.titleLarge(text: title),
                      const SizedBox(height: 8),
                      Wrap(spacing: 6, runSpacing: 6, children: badges),
                      const SizedBox(height: 16),
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 8, AppStyles.screenPadding, 12),
                child: bottom,
              ),
          ],
        ),
      ),
    );
  }
}

/// Valider / Refuser pair.
class ValidationActions extends StatelessWidget {
  /// A null callback means the action is not allowed for this status — the
  /// button is left out rather than disabled.
  const ValidationActions({super.key, this.onValidate, this.onRefuse, this.isBusy = false});

  final VoidCallback? onValidate;
  final VoidCallback? onRefuse;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onValidate != null)
          Expanded(
            child: CustomButton.filled(
              onPressed: onValidate,
              text: 'common.validate'.tr(),
              color: AppColors.greenColor,
              isLoading: isBusy,
            ),
          ),
        if (onValidate != null && onRefuse != null) const SizedBox(width: 8),
        if (onRefuse != null)
          Expanded(
            child: CustomButton.filled(
              onPressed: isBusy ? null : onRefuse,
              text: 'common.refuse'.tr(),
              color: AppColors.redColor,
              isLoading: isBusy && onValidate == null,
            ),
          ),
      ],
    );
  }
}
