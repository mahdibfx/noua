import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/views/home/home_view.dart';
import 'package:noua/ui/views/payment_requests/payment_requests_view.dart';
import 'package:noua/ui/views/profile/profile_view.dart';
import 'package:noua/ui/views/purchase_orders/purchase_orders_view.dart';
import 'package:noua/ui/views/purchase_requests/purchase_requests_view.dart';
import 'package:noua/ui/views/retraits/retraits_view.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';
import 'widgets/bottom_tab_bar.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: viewModel.currentIndex,
          children: [
            HomeView(onOpenTab: viewModel.onTabTap),
            const PurchaseRequestsView(),
            const PurchaseOrdersView(),
            const PaymentRequestsView(),
            const RetraitsView(),
            const ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomTabBar(currentIndex: viewModel.currentIndex, onTap: viewModel.onTabTap),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
