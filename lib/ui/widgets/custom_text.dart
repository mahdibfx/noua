import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';

// ponytail: system font (matches the maquette). Add a family in pubspec + here if branding needs one.
class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.height,
  });

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: true,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        color: textColor ?? AppColors.textColor,
        fontWeight: fontWeight,
        height: height,
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
    );
  }

  /// Login heading
  factory CustomText.headline({required String text, Color? textColor, TextAlign? textAlign}) =>
      CustomText(text, fontSize: 22, fontWeight: FontWeight.w600, textColor: textColor, textAlign: textAlign);

  /// Screen titles
  factory CustomText.titleLarge({required String text, Color? textColor, int? maxLines}) =>
      CustomText(text, fontSize: 20, fontWeight: FontWeight.w600, textColor: textColor, maxLines: maxLines);

  /// Metric values, totals
  factory CustomText.titleSmall({required String text, Color? textColor, TextAlign? textAlign}) =>
      CustomText(text, fontSize: 17, fontWeight: FontWeight.w600, textColor: textColor, textAlign: textAlign);

  /// Card titles, item names
  factory CustomText.bodyLarge({required String text, Color? textColor, int? maxLines, TextAlign? textAlign}) =>
      CustomText(text, fontSize: 15, fontWeight: FontWeight.w600, textColor: textColor, maxLines: maxLines, textAlign: textAlign);

  factory CustomText.bodyMedium({required String text, Color? textColor, int? maxLines, TextAlign? textAlign, FontWeight? fontWeight}) =>
      CustomText(text, fontSize: 14, fontWeight: fontWeight ?? FontWeight.w500, textColor: textColor, maxLines: maxLines, textAlign: textAlign);

  /// Labels, card subtitles
  factory CustomText.bodySmall({required String text, Color? textColor, int? maxLines, TextAlign? textAlign, FontWeight? fontWeight}) =>
      CustomText(text, fontSize: 13, fontWeight: fontWeight ?? FontWeight.w400, textColor: textColor ?? AppColors.secondaryColor, maxLines: maxLines, textAlign: textAlign);

  /// Pills, hints, bottom nav
  factory CustomText.caption({required String text, Color? textColor, FontWeight? fontWeight, TextAlign? textAlign, int? maxLines}) =>
      CustomText(text, fontSize: 11, fontWeight: fontWeight ?? FontWeight.w400, textColor: textColor ?? AppColors.secondaryColor, textAlign: textAlign, maxLines: maxLines);
}
