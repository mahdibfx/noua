import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/common/app_styles.dart';
import 'package:noua/ui/common/ui_helpers.dart';
import 'package:noua/ui/widgets/custom_button.dart';
import 'package:noua/ui/widgets/custom_input.dart';
import 'package:noua/ui/widgets/custom_text.dart';
import 'package:noua/ui/widgets/fade_in_up.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: FadeInUp(
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColorLight,
                          borderRadius: BorderRadius.circular(AppStyles.borderRadiusLargeValue),
                        ),
                        child: const CustomText('N', fontSize: 28, fontWeight: FontWeight.w700, textColor: AppColors.primaryColor),
                      ),
                    ),
                    verticalSpaceSmall,
                    CustomText.headline(text: 'login.title'.tr(), textAlign: TextAlign.center),
                    verticalSpaceTiny,
                    CustomText.bodySmall(text: 'login.subtitle'.tr(), textAlign: TextAlign.center, maxLines: 2),
                    verticalSpaceMedium,
                    CustomInput(
                      controller: viewModel.usernameController,
                      label: 'login.username'.tr(),
                      hintText: 'login.username_hint'.tr(),
                      validator: viewModel.requiredValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    verticalSpace(14),
                    CustomInput(
                      controller: viewModel.passwordController,
                      label: 'login.password'.tr(),
                      hintText: '••••••••',
                      obscureText: true,
                      validator: viewModel.requiredValidator,
                      textInputAction: TextInputAction.done,
                    ),
                    verticalSpace(20),
                    CustomButton.filled(onPressed: viewModel.onLoginTap, text: 'login.submit'.tr(), isLoading: viewModel.isBusy),
                    verticalSpace(14),
                    CustomText.caption(text: 'login.footer'.tr(), textColor: AppColors.mutedColor, textAlign: TextAlign.center, maxLines: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
