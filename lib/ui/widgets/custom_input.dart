import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmallValue),
      borderSide: const BorderSide(color: AppColors.borderColor),
    );
    Widget field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly || onTap != null,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.mutedColor),
        filled: true,
        isDense: true,
        fillColor: AppColors.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.primaryColor)),
        errorBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.redColor)),
        focusedErrorBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.redColor)),
      ),
    );

    // Picker trigger: make the whole field tappable.
    if (onTap != null) {
      field = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AbsorbPointer(child: field),
      );
    }

    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.bodySmall(text: label!),
        const SizedBox(height: 4),
        field,
      ],
    );
  }
}
