import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.label, required this.value, required this.color, required this.background});

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMediumValue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.caption(text: label, textColor: color),
          const SizedBox(height: 4),
          CustomText.titleSmall(text: value, textColor: color),
        ],
      ),
    );
  }
}
