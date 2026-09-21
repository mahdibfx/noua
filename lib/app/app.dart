import 'package:noua/services/api/api_auth_service.dart';
import 'package:noua/services/api/api_manager_service.dart';
import 'package:noua/services/auth_service.dart';
import 'package:noua/services/dio_service.dart';
import 'package:noua/services/manager_service.dart';
import 'package:noua/ui/views/login/login_view.dart';
import 'package:noua/ui/views/main/main_view.dart';
import 'package:noua/ui/views/payment_request_details/payment_request_details_view.dart';
import 'package:noua/ui/views/purchase_order_details/purchase_order_details_view.dart';
import 'package:noua/ui/views/purchase_request_details/purchase_request_details_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: MainView),
    MaterialRoute(page: PurchaseRequestDetailsView),
    MaterialRoute(page: PurchaseOrderDetailsView),
    MaterialRoute(page: PaymentRequestDetailsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DioService),
    LazySingleton(classType: ApiAuthService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ApiManagerService),
    LazySingleton(classType: ManagerService),
// @stacked-service
  ],
)
class App {}
