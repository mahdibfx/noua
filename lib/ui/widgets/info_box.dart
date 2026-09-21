import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

/// Grey rounded block used on every detail screen.
class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMediumValue),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({super.key, required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.bodySmall(text: label),
          const SizedBox(width: 12),
          Expanded(child: CustomText.bodySmall(text: value, textColor: AppColors.textColor, textAlign: TextAlign.end, maxLines: 2)),
        ],
      ),
    );
  }
}

/// "Total TTC ....... 41 650.00 DA"
class AmountBox extends StatelessWidget {
  const AmountBox({super.key, required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return InfoBox(children: [
      Row(
        children: [
          Expanded(child: CustomText.bodySmall(text: label)),
          CustomText.titleSmall(text: amount),
        ],
      ),
    ]);
  }
}

/// Three-column quantity grid (Demandée / Commandée / Restée ...).
class QuantityGrid extends StatelessWidget {
  const QuantityGrid({super.key, required this.entries});

  final List<(String label, String value)> entries;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (label, value) in entries)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.caption(text: label),
                const SizedBox(height: 2),
                CustomText.bodyMedium(text: value, fontWeight: FontWeight.w600),
              ],
            ),
          ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomText.bodySmall(text: text),
    );
  }
}
