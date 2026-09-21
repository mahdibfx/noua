import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color, required this.background});

  final String label;
  final Color color;
  final Color background;

  factory StatusPill.info(String label) =>
      StatusPill(label: label, color: AppColors.primaryColor, background: AppColors.primaryColorLight);

  factory StatusPill.neutral(String label) =>
      StatusPill(label: label, color: AppColors.secondaryColor, background: AppColors.surfaceAltColor);

  /// Purchase request priority 1–4; unknown values render nothing useful, so
  /// callers should skip the pill when [priority] is 0.
  factory StatusPill.priority(int priority, {bool long = false}) {
    final label = 'priority.$priority'.tr();
    final text = long ? 'priority.long'.tr(args: [label.toLowerCase()]) : label;
    return priority >= 3
        ? StatusPill(label: text, color: AppColors.redColor, background: AppColors.redColorLight)
        : StatusPill.neutral(text);
  }

  /// [apiLabel] is the server's own wording (status_label) when available.
  factory StatusPill.status(DocStatus status, {String? apiLabel}) {
    final label = (apiLabel == null || apiLabel.isEmpty) ? status.label : apiLabel;
    return switch (status) {
      DocStatus.validee => StatusPill(label: label, color: AppColors.greenColor, background: AppColors.greenColorLight),
      DocStatus.annulee => StatusPill(label: label, color: AppColors.redColor, background: AppColors.redColorLight),
      DocStatus.inconnu => StatusPill.neutral(label),
      _ => StatusPill(label: label, color: AppColors.orangeColor, background: AppColors.orangeColorLight),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusTinyValue),
      ),
      child: CustomText.caption(text: label, textColor: color, fontWeight: FontWeight.w600),
    );
  }
}
