import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/api_response.dart';
import 'package:noua/models/json.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/api/api_endpoints.dart';
import 'package:noua/services/dio_service.dart';

class LoginResult {
  const LoginResult({required this.token, required this.user});
  final String token;
  final UserModel user;
}

class ApiAuthService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<LoginResult>> login({required String username, required String password}) async {
    final res = await _dio.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );
    return ApiResponse<LoginResult>.fromJson(asMap(res.data), res.statusCode!, (data) {
      final map = asMap(data);
      return LoginResult(
        token: pickString(map, ['token', 'access_token', 'bearer_token']),
        user: UserModel.fromJson(asMap(pick(map, ['user'])).isEmpty ? map : asMap(map['user'])),
      );
    });
  }

  Future<ApiResponse<Unit>> logout() async {
    final res = await _dio.post(ApiEndpoints.logout);
    return ApiResponse<Unit>.fromJson(asMap(res.data), res.statusCode!, (_) => unit);
  }

  Future<ApiResponse<UserModel>> fetchProfile() async {
    final res = await _dio.get(ApiEndpoints.profile);
    return ApiResponse<UserModel>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => UserModel.fromJson(asMap(asMap(data)['user'])),
    );
  }

  Future<ApiResponse<Unit>> changePassword({
    required String currentPassword,
    required String password,
  }) async {
    final res = await _dio.put(ApiEndpoints.password, data: {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': password,
    });
    return ApiResponse<Unit>.fromJson(asMap(res.data), res.statusCode!, (_) => unit);
  }
}
