import 'package:fpdart/fpdart.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/extensions/api_response_extension.dart';
import 'package:noua/models/failure.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/api/api_manager_service.dart';

/// `status` filter values accepted by the three list endpoints.
class DocFilter {
  static const String enAttente = 'en_attente';
  static const String enCours = 'en_cours';
}

class ManagerService {
  final _api = locator<ApiManagerService>();

  Future<Either<Failure, DashboardStats>> fetchDashboard({String? dateFrom, String? dateTo}) =>
      _api.fetchDashboard(dateFrom: dateFrom, dateTo: dateTo).toEither();

  Future<Either<Failure, List<PurchaseRequest>>> fetchPurchaseRequests({String? status}) =>
      _api.fetchPurchaseRequests(status: status).toEither();

  Future<Either<Failure, PurchaseRequest>> fetchPurchaseRequest(int id) =>
      _api.fetchPurchaseRequest(id).toEither();

  Future<Either<Failure, Unit>> setPurchaseRequestStatus(int id, {required String action}) =>
      _api.setPurchaseRequestStatus(id, action: action).toEither();

  Future<Either<Failure, List<CommandOrder>>> fetchCommandOrders({String? status}) =>
      _api.fetchCommandOrders(status: status).toEither();

  Future<Either<Failure, CommandOrder>> fetchCommandOrder(int id) =>
      _api.fetchCommandOrder(id).toEither();

  Future<Either<Failure, Unit>> setCommandOrderStatus(int id, {required String action}) =>
      _api.setCommandOrderStatus(id, action: action).toEither();

  Future<Either<Failure, List<PaymentRequest>>> fetchPaymentRequests({String? status}) =>
      _api.fetchPaymentRequests(status: status).toEither();

  Future<Either<Failure, PaymentRequest>> fetchPaymentRequest(int id) =>
      _api.fetchPaymentRequest(id).toEither();
}
