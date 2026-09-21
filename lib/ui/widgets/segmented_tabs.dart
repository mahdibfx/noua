import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

/// Equal-width toggle buttons (En attente / Historique, Jour / Semaine / ...).
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({super.key, required this.labels, required this.selectedIndex, required this.onChanged});

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: i == selectedIndex ? AppColors.primaryColor : AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmallValue),
                  border: Border.all(color: i == selectedIndex ? AppColors.primaryColor : AppColors.borderColor),
                ),
                child: CustomText.bodySmall(
                  text: labels[i],
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  textColor: i == selectedIndex ? Colors.white : AppColors.textColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
