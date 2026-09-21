import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/extensions/api_response_extension.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/api/api_auth_service.dart';
import 'package:noua/services/dio_service.dart';

class AuthService {
  final _api = locator<ApiAuthService>();
  final _dioService = locator<DioService>();

  UserModel? currentUser;

  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  }) async {
    final result = await _api.login(username: username, password: password).toEither();
    return result.fold<Future<Either<Failure, UserModel>>>(
      (failure) async => Either.left(failure),
      (login) async {
        await _dioService.saveToken(login.token);
        currentUser = login.user;
        return Either.right(login.user);
      },
    );
  }

  Future<Either<Failure, UserModel>> fetchProfile() async {
    final result = await _api.fetchProfile().toEither();
    result.map((user) => currentUser = user);
    return result;
  }

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String password,
  }) =>
      _api.changePassword(currentPassword: currentPassword, password: password).toEither();

  /// Revokes the token server-side when possible, and always clears it locally.
  Future<void> logout() async {
    await _api.logout().toEither();
    await _dioService.deleteToken();
    currentUser = null;
  }
}
