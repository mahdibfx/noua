import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/api_response.dart';
import 'package:noua/models/json.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/api/api_endpoints.dart';
import 'package:noua/services/dio_service.dart';

/// Dashboard + the three purchase-workflow modules.
class ApiManagerService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<DashboardStats>> fetchDashboard({String? dateFrom, String? dateTo}) async {
    final res = await _dio.get(ApiEndpoints.dashboard, queryParameters: {
      'date_from': ?dateFrom,
      'date_to': ?dateTo,
    });
    return ApiResponse<DashboardStats>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => DashboardStats.fromJson(asMap(data)),
    );
  }

  // --- Demandes d'achat ---

  Future<ApiResponse<List<PurchaseRequest>>> fetchPurchaseRequests({String? status}) async {
    final res = await _dio.get(ApiEndpoints.purchaseOrders, queryParameters: {
      'status': ?status,
    });
    return ApiResponse<List<PurchaseRequest>>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => asMapList(data).map(PurchaseRequest.fromJson).toList(),
    );
  }

  Future<ApiResponse<PurchaseRequest>> fetchPurchaseRequest(int id) async {
    final res = await _dio.get(ApiEndpoints.purchaseOrder(id));
    return ApiResponse<PurchaseRequest>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => PurchaseRequest.fromJson(asMap(data)),
    );
  }

  Future<ApiResponse<Unit>> setPurchaseRequestStatus(int id, {required String action}) async {
    final res = await _dio.post(ApiEndpoints.purchaseOrderStatus(id), data: {'action': action});
    return ApiResponse<Unit>.fromJson(asMap(res.data), res.statusCode!, (_) => unit);
  }

  // --- Bons de commande ---

  Future<ApiResponse<List<CommandOrder>>> fetchCommandOrders({String? status}) async {
    final res = await _dio.get(ApiEndpoints.commandOrders, queryParameters: {
      'status': ?status,
    });
    return ApiResponse<List<CommandOrder>>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => asMapList(data).map(CommandOrder.fromJson).toList(),
    );
  }

  Future<ApiResponse<CommandOrder>> fetchCommandOrder(int id) async {
    final res = await _dio.get(ApiEndpoints.commandOrder(id));
    return ApiResponse<CommandOrder>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => CommandOrder.fromJson(asMap(data)),
    );
  }

  Future<ApiResponse<Unit>> setCommandOrderStatus(int id, {required String action}) async {
    final res = await _dio.post(ApiEndpoints.commandOrderStatus(id), data: {
      'action': action,
      if (action == 'cancel') 'restore_related_demands': true,
    });
    return ApiResponse<Unit>.fromJson(asMap(res.data), res.statusCode!, (_) => unit);
  }

  // --- Demandes de paiement ---

  Future<ApiResponse<List<PaymentRequest>>> fetchPaymentRequests({String? status}) async {
    final res = await _dio.get(ApiEndpoints.paymentRequests, queryParameters: {
      'status': ?status,
    });
    return ApiResponse<List<PaymentRequest>>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => asMapList(data).map(PaymentRequest.fromJson).toList(),
    );
  }

  Future<ApiResponse<PaymentRequest>> fetchPaymentRequest(int id) async {
    final res = await _dio.get(ApiEndpoints.paymentRequest(id));
    return ApiResponse<PaymentRequest>.fromJson(
      asMap(res.data),
      res.statusCode!,
      (data) => PaymentRequest.fromJson(asMap(data)),
    );
  }
}
