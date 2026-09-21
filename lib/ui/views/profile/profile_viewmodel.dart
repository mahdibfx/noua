import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _authService = locator<AuthService>();

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  UserModel? get user => _authService.currentUser;
  String get fullName => user?.fullName ?? '';
  String get position => user?.position ?? '';
  String get initials => user?.initials ?? '?';

  Future<void> init() async {
    setBusy(true);
    final result = await _authService.fetchProfile();
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (_) {},
    );
  }

  String? requiredValidator(String? v) => (v == null || v.isEmpty) ? 'common.required'.tr() : null;

  // The API rejects anything under 8 characters.
  String? newPasswordValidator(String? v) =>
      requiredValidator(v) ?? (v!.length < 8 ? 'profile.too_short'.tr() : null);

  String? confirmPasswordValidator(String? v) =>
      requiredValidator(v) ?? (v != newPasswordController.text ? 'profile.mismatch'.tr() : null);

  Future<void> onUpdatePasswordTap() async {
    if (isBusy || !formKey.currentState!.validate()) return;
    setBusy(true);
    final result = await _authService.changePassword(
      currentPassword: currentPasswordController.text,
      password: newPasswordController.text,
    );
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(
        message: failure is ValidationFailure ? failure.firstError ?? failure.message : failure.message,
        duration: const Duration(seconds: 3),
      ),
      (_) {
        formKey.currentState!.reset();
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        _snackbarService.showSnackbar(message: 'profile.updated'.tr(), duration: const Duration(seconds: 2));
      },
    );
  }

  Future<void> onLogoutTap() async {
    setBusy(true);
    await _authService.logout();
    setBusy(false);
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
