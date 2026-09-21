/// Central registry of API routes. All paths are relative to [base].
class ApiEndpoints {
  static const String base = 'https://demo.smartvision-dz.com';

  // Auth & profile
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String profile = '/api/profile';
  static const String password = '/api/profile/password';

  // Dashboard
  static const String dashboard = '/api/dashboard';

  // Demandes d'achat
  static const String purchaseOrders = '/api/purchase-orders';
  static String purchaseOrder(Object id) => '/api/purchase-orders/detail/$id';
  static String purchaseOrderStatus(Object id) => '/api/purchase-orders/status/$id';

  // Bons de commande
  static const String commandOrders = '/api/command-orders';
  static String commandOrder(Object id) => '/api/command-orders/detail/$id';
  static String commandOrderStatus(Object id) => '/api/command-orders/status/$id';

  // Demandes de paiement
  static const String paymentRequests = '/api/payment-requests';
  static String paymentRequest(Object id) => '/api/payment-requests/detail/$id';
}
