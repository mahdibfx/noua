import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

enum ButtonType { filled, outlined }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.expanded = true,
    this.color = AppColors.primaryColor,
    this.buttonType = ButtonType.filled,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool expanded;
  final Color color;
  final ButtonType buttonType;

  factory CustomButton.filled({required VoidCallback? onPressed, required String text, bool isLoading = false, bool expanded = true, Color color = AppColors.primaryColor}) =>
      CustomButton(onPressed: onPressed, text: text, isLoading: isLoading, expanded: expanded, color: color);

  factory CustomButton.outlined({required VoidCallback? onPressed, required String text, bool expanded = true, Color color = AppColors.textColor}) =>
      CustomButton(onPressed: onPressed, text: text, expanded: expanded, color: color, buttonType: ButtonType.outlined);

  @override
  Widget build(BuildContext context) {
    final filled = buttonType == ButtonType.filled;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmallValue),
      side: BorderSide(color: filled ? color : (color == AppColors.textColor ? AppColors.borderColor : color)),
    );
    return SizedBox(
      width: expanded ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: shape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          backgroundColor: filled ? color : AppColors.surfaceColor,
          disabledBackgroundColor: filled ? color.withValues(alpha: .6) : AppColors.surfaceColor,
          foregroundColor: filled ? Colors.white : color,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : CustomText.bodyMedium(text: text, textColor: filled ? Colors.white : color),
        ),
      ),
    );
  }
}
