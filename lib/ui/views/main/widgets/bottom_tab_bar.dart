import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/widgets/custom_text.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    (Icons.home_outlined, Icons.home, 'nav.home'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'nav.purchases'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'nav.orders'),
    (Icons.payments_outlined, Icons.payments, 'nav.payments'),
    (Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'nav.retraits'),
    (Icons.person_outline, Icons.person, 'nav.profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 4, AppStyles.screenPadding, 8),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusExtraLargeValue),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppStyles.borderRadiusMediumValue),
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            i == currentIndex ? _tabs[i].$2 : _tabs[i].$1,
                            key: ValueKey(i == currentIndex),
                            size: 20,
                            color: i == currentIndex ? AppColors.primaryColor : AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          _tabs[i].$3.tr(),
                          fontSize: 9.5,
                          textAlign: TextAlign.center,
                          fontWeight: i == currentIndex ? FontWeight.w600 : FontWeight.w400,
                          textColor: i == currentIndex ? AppColors.primaryColor : AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
