import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/models/api_response.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/services/dio_service.dart';
import 'package:noua/ui/common/app_strings.dart';
import 'package:stacked_services/stacked_services.dart';

/// Turns a raw API call (`Future<ApiResponse<T>>`) into a
/// `Future<Either<Failure, T>>`. Only business services call this.
extension ApiResponseExtension<T> on Future<ApiResponse<T>> {
  Future<Either<Failure, T>> toEither() async {
    try {
      final response = await this;
      if (response.success) {
        return Either.right(response.data as T);
      }
      if (response.errors.isNotEmpty) {
        return Either.left(
          ValidationFailure(response.message ?? AppStrings.validationError, response.errors),
        );
      }
      return Either.left(GeneralFailure(response.message ?? AppStrings.unknownError));
    } on DioException catch (e) {
      return Either.left(_mapDioException(e));
    } catch (e) {
      return Either.left(GeneralFailure(e.toString()));
    }
  }
}

Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return GeneralFailure(AppStrings.timeout);
    case DioExceptionType.connectionError:
      return NoInternetFailure();
    case DioExceptionType.cancel:
      return GeneralFailure(AppStrings.cancel);
    case DioExceptionType.badCertificate:
      return GeneralFailure(AppStrings.badCertificate);
    case DioExceptionType.badResponse:
      return _mapResponse(e.response);
    case DioExceptionType.unknown:
    default:
      return GeneralFailure(AppStrings.unknownError);
  }
}

Failure _mapResponse(Response? response) {
  if (response == null) return GeneralFailure(AppStrings.unknownError);

  final data = response.data;
  final message = data is Map && data['message'] is String ? data['message'] as String : null;
  final errors = data is Map && data['errors'] is Map<String, dynamic>
      ? data['errors'] as Map<String, dynamic>
      : const <String, dynamic>{};

  switch (response.statusCode) {
    case 400:
      return ValidationFailure(message ?? AppStrings.validationError, errors);
    case 401:
      _handleUnauthorized();
      return GeneralFailure(AppStrings.sessionExpired);
    case 403:
      return GeneralFailure(message ?? AppStrings.forbidden);
    case 404:
      return GeneralFailure(message ?? AppStrings.notFound);
    case 422:
      return ValidationFailure(message ?? AppStrings.validationError, errors);
    case 500:
      return GeneralFailure(message ?? AppStrings.internalServerError);
    default:
      if (errors.isNotEmpty) {
        return ValidationFailure(message ?? AppStrings.validationError, errors);
      }
      return GeneralFailure(message ?? AppStrings.unknownError);
  }
}

/// Clears the session and routes back to login on an expired/invalid token.
void _handleUnauthorized() {
  Future.delayed(const Duration(milliseconds: 300), () async {
    await locator<DioService>().deleteToken();
    locator<NavigationService>().clearStackAndShow(Routes.loginView);
  });
}
