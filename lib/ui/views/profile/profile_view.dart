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

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppStyles.screenPadding, 16, AppStyles.screenPadding, 16),
      child: FadeInUp(
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryColorLight,
                    child: CustomText.bodyMedium(text: viewModel.initials, textColor: AppColors.primaryColor, fontWeight: FontWeight.w600),
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.bodyLarge(text: viewModel.fullName),
                        CustomText.bodySmall(text: viewModel.position.isEmpty ? 'profile.role'.tr() : viewModel.position),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace(24),
              CustomText.bodySmall(text: 'profile.change_password'.tr(), fontWeight: FontWeight.w600),
              verticalSpace(12),
              CustomInput(
                controller: viewModel.currentPasswordController,
                label: 'profile.current_password'.tr(),
                obscureText: true,
                validator: viewModel.requiredValidator,
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),
              CustomInput(
                controller: viewModel.newPasswordController,
                label: 'profile.new_password'.tr(),
                obscureText: true,
                validator: viewModel.newPasswordValidator,
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),
              CustomInput(
                controller: viewModel.confirmPasswordController,
                label: 'profile.confirm_password'.tr(),
                obscureText: true,
                validator: viewModel.confirmPasswordValidator,
                textInputAction: TextInputAction.done,
              ),
              verticalSpace(18),
              CustomButton.filled(onPressed: viewModel.onUpdatePasswordTap, text: 'profile.submit'.tr(), isLoading: viewModel.isBusy),
              verticalSpace(8),
              CustomButton.outlined(onPressed: viewModel.onLogoutTap, text: 'profile.logout'.tr(), color: AppColors.redColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
