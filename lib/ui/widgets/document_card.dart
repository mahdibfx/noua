import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

/// List card shared by purchase requests, purchase orders and payment requests.
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.title,
    required this.badge,
    required this.subtitles,
    required this.onTap,
    this.footer,
  });

  final String title;
  final Widget badge;
  final List<String> subtitles;
  final Widget? footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusLargeValue),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusLargeValue),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: CustomText.bodyLarge(text: title)),
                      const SizedBox(width: 8),
                      badge,
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final s in subtitles) ...[
                    CustomText.bodySmall(text: s, maxLines: 2),
                    const SizedBox(height: 2),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: footer ?? const SizedBox.shrink(),
                        ),
                      ),
                      CustomText.bodySmall(
                        text: '${'common.see_detail'.tr()} ›',
                        textColor: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
