// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter/foundation.dart' as _i8;
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:noua/models/manager_models.dart' as _i9;
import 'package:noua/ui/views/login/login_view.dart' as _i2;
import 'package:noua/ui/views/main/main_view.dart' as _i3;
import 'package:noua/ui/views/payment_request_details/payment_request_details_view.dart'
    as _i6;
import 'package:noua/ui/views/purchase_order_details/purchase_order_details_view.dart'
    as _i5;
import 'package:noua/ui/views/purchase_request_details/purchase_request_details_view.dart'
    as _i4;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;

class Routes {
  static const loginView = '/';

  static const mainView = '/main-view';

  static const purchaseRequestDetailsView = '/purchase-request-details-view';

  static const purchaseOrderDetailsView = '/purchase-order-details-view';

  static const paymentRequestDetailsView = '/payment-request-details-view';

  static const all = <String>{
    loginView,
    mainView,
    purchaseRequestDetailsView,
    purchaseOrderDetailsView,
    paymentRequestDetailsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.loginView, page: _i2.LoginView),
    _i1.RouteDef(Routes.mainView, page: _i3.MainView),
    _i1.RouteDef(
      Routes.purchaseRequestDetailsView,
      page: _i4.PurchaseRequestDetailsView,
    ),
    _i1.RouteDef(
      Routes.purchaseOrderDetailsView,
      page: _i5.PurchaseOrderDetailsView,
    ),
    _i1.RouteDef(
      Routes.paymentRequestDetailsView,
      page: _i6.PaymentRequestDetailsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.LoginView(key: args.key),
        settings: data,
      );
    },
    _i3.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.MainView(key: args.key),
        settings: data,
      );
    },
    _i4.PurchaseRequestDetailsView: (data) {
      final args = data.getArgs<PurchaseRequestDetailsViewArguments>(
        nullOk: false,
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.PurchaseRequestDetailsView(
          key: args.key,
          request: args.request,
        ),
        settings: data,
      );
    },
    _i5.PurchaseOrderDetailsView: (data) {
      final args = data.getArgs<PurchaseOrderDetailsViewArguments>(
        nullOk: false,
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i5.PurchaseOrderDetailsView(key: args.key, order: args.order),
        settings: data,
      );
    },
    _i6.PaymentRequestDetailsView: (data) {
      final args = data.getArgs<PaymentRequestDetailsViewArguments>(
        nullOk: false,
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.PaymentRequestDetailsView(key: args.key, payment: args.payment),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class MainViewArguments {
  const MainViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant MainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PurchaseRequestDetailsViewArguments {
  const PurchaseRequestDetailsViewArguments({this.key, required this.request});

  final _i8.Key? key;

  final _i9.PurchaseRequest request;

  @override
  String toString() {
    return '{"key": "$key", "request": "$request"}';
  }

  @override
  bool operator ==(covariant PurchaseRequestDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.request == request;
  }

  @override
  int get hashCode {
    return key.hashCode ^ request.hashCode;
  }
}

class PurchaseOrderDetailsViewArguments {
  const PurchaseOrderDetailsViewArguments({this.key, required this.order});

  final _i8.Key? key;

  final _i9.CommandOrder order;

  @override
  String toString() {
    return '{"key": "$key", "order": "$order"}';
  }

  @override
  bool operator ==(covariant PurchaseOrderDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.order == order;
  }

  @override
  int get hashCode {
    return key.hashCode ^ order.hashCode;
  }
}

class PaymentRequestDetailsViewArguments {
  const PaymentRequestDetailsViewArguments({this.key, required this.payment});

  final _i8.Key? key;

  final _i9.PaymentRequest payment;

  @override
  String toString() {
    return '{"key": "$key", "payment": "$payment"}';
  }

  @override
  bool operator ==(covariant PaymentRequestDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.payment == payment;
  }

  @override
  int get hashCode {
    return key.hashCode ^ payment.hashCode;
  }
}

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToLoginView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMainView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.mainView,
      arguments: MainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPurchaseRequestDetailsView({
    _i8.Key? key,
    required _i9.PurchaseRequest request,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.purchaseRequestDetailsView,
      arguments: PurchaseRequestDetailsViewArguments(
        key: key,
        request: request,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPurchaseOrderDetailsView({
    _i8.Key? key,
    required _i9.CommandOrder order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.purchaseOrderDetailsView,
      arguments: PurchaseOrderDetailsViewArguments(key: key, order: order),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPaymentRequestDetailsView({
    _i8.Key? key,
    required _i9.PaymentRequest payment,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.paymentRequestDetailsView,
      arguments: PaymentRequestDetailsViewArguments(key: key, payment: payment),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithMainView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.mainView,
      arguments: MainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPurchaseRequestDetailsView({
    _i8.Key? key,
    required _i9.PurchaseRequest request,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.purchaseRequestDetailsView,
      arguments: PurchaseRequestDetailsViewArguments(
        key: key,
        request: request,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPurchaseOrderDetailsView({
    _i8.Key? key,
    required _i9.CommandOrder order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.purchaseOrderDetailsView,
      arguments: PurchaseOrderDetailsViewArguments(key: key, order: order),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPaymentRequestDetailsView({
    _i8.Key? key,
    required _i9.PaymentRequest payment,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.paymentRequestDetailsView,
      arguments: PaymentRequestDetailsViewArguments(key: key, payment: payment),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
