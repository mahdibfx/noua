import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _authService = locator<AuthService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? requiredValidator(String? value) =>
      (value == null || value.trim().isEmpty) ? 'common.required'.tr() : null;

  Future<void> onLoginTap() async {
    if (isBusy || !formKey.currentState!.validate()) return;
    setBusy(true);
    final result = await _authService.login(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(
        message: failure is ValidationFailure ? failure.firstError ?? failure.message : failure.message,
        duration: const Duration(seconds: 3),
      ),
      (_) => _navigationService.clearStackAndShow(Routes.mainView),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
