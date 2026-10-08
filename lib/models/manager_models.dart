import 'package:easy_localization/easy_localization.dart';
import 'package:noua/models/json.dart';

/// Web status codes shared by the three purchase-workflow modules.
enum DocStatus {
  enAttente(6),
  enCours(1),
  partielle(4),
  validee(2),
  annulee(3),
  // Downstream demande d'achat states seen on the demo server (not in API.md).
  enTraitement(7),
  commandee(8),
  receptionne(0),
  inconnu(-1);

  const DocStatus(this.code);
  final int code;

  static DocStatus fromCode(int? code) =>
      DocStatus.values.firstWhere((e) => e.code == code, orElse: () => DocStatus.inconnu);

  /// Demandes d'achat: only "En cours" can be validated or refused
  /// (decision 21/09/2026) — also what their "En attente" tab lists.
  bool get isPending => this == enCours;

  String get label => 'status.$name'.tr();
}

enum DashboardPeriod { day, week, month, custom }

class DashboardStats {
  const DashboardStats({
    required this.revenue,
    required this.collections,
    required this.purchases,
    required this.supplierPayments,
    required this.withdrawals,
    required this.customersBalance,
    required this.suppliersBalance,
    required this.pendingPurchaseRequests,
    required this.pendingOrders,
  });

  final double revenue;
  final double collections;
  final double purchases;
  final double supplierPayments;
  /// Retraits (décaissements) — total cashout over the period.
  final double withdrawals;
  final double customersBalance;
  final double suppliersBalance;
  final int pendingPurchaseRequests;
  final int pendingOrders;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
        revenue: pickDouble(json, ['ca']),
        collections: pickDouble(json, ['recouvrement']),
        purchases: pickDouble(json, ['achats']),
        supplierPayments: pickDouble(json, ['reglement_fournisseurs']),
        withdrawals: pickDouble(json, ['retraits']),
        customersBalance: pickDouble(json, ['solde_total_clients']),
        suppliersBalance: pickDouble(json, ['solde_total_fournisseurs']),
        pendingPurchaseRequests: pickInt(json, ['achats_en_attente_validation']),
        pendingOrders: pickInt(json, ['commandes_en_attente_validation']),
      );
}

class UserModel {
  const UserModel({required this.fullName, required this.username, required this.position});

  final String fullName;
  final String username;
  final String position;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: pickString(json, ['full_name', 'username']),
        username: pickString(json, ['username']),
        position: pickString(json, ['position', 'service_name', 'type_service_name', 'role_name']),
      );

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((e) => e[0]).join().toUpperCase();
  }
}

/// Demande d'achat — `/api/purchase-orders`.
class PurchaseRequest {
  PurchaseRequest({
    required this.id,
    required this.reference,
    required this.date,
    required this.requester,
    required this.site,
    required this.type,
    required this.status,
    required this.statusLabel,
    required this.createdBy,
    required this.priority,
    this.beb,
    this.products = const [],
  });

  final int id;
  final String reference;
  final String date;
  final String requester;
  /// 1 Basse, 2 Normale, 3 Haute, 4 Urgente — labels chosen by us, matching
  /// the maquette (DA00030 = 3 "Haute", DA00029 = 4 "Urgente").
  final int priority;
  final String site;
  final String type;
  String statusLabel;
  final String createdBy;
  final String? beb;
  final List<DocumentProduct> products;
  DocStatus status;

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) => PurchaseRequest(
        id: pickInt(json, ['id']),
        reference: pickString(json, ['reference']),
        date: pickString(json, ['date']),
        requester: pickString(json, ['demandeur_name', 'demandeur']),
        site: pickString(json, ['site_name', 'site']),
        type: pickString(json, ['type_label', 'type_name']),
        status: DocStatus.fromCode(pickInt(json, ['status_code'], fallback: -1)),
        statusLabel: pickString(json, ['status_label', 'status_name']),
        createdBy: pickString(json, ['created_by_name', 'created_by']),
        priority: pickInt(json, ['priority']),
        beb: pickStringOrNull(json, ['beb_reference', 'beb']),
        products: asMapList(json['products']).map(DocumentProduct.fromJson).toList(),
      );
}

/// Bon de commande — `/api/command-orders`.
class CommandOrder {
  CommandOrder({
    required this.id,
    required this.reference,
    required this.date,
    required this.supplier,
    required this.service,
    required this.site,
    required this.paymentMode,
    required this.deliveryDate,
    required this.totalTtc,
    required this.status,
    required this.statusLabel,
    required this.createdBy,
    this.products = const [],
  });

  final int id;
  final String reference;
  final String date;
  final String supplier;
  final String service;
  final String site;
  final String paymentMode;
  final String deliveryDate;
  final double totalTtc;
  String statusLabel;
  final String createdBy;
  final List<DocumentProduct> products;
  DocStatus status;

  /// Backend rules (Yanis, 22/09/2026): validate only "Partielle", cancel only
  /// "En cours" (and "Satisfait" — status code still unknown, see
  /// BACKEND_QUESTIONS).
  bool get canValidate => status == DocStatus.partielle;
  bool get canCancel => status == DocStatus.enCours;

  /// What the "En attente" tab lists — same set as `?status=en_attente`.
  bool get isActionable => canValidate || canCancel;

  factory CommandOrder.fromJson(Map<String, dynamic> json) {
    final code = pickStringOrNull(json, ['supplier_code']);
    final name = pickString(json, ['supplier_name']).replaceAll(RegExp(r'\s+'), ' ').trim();
    return CommandOrder(
      id: pickInt(json, ['id']),
      reference: pickString(json, ['reference']),
      date: pickString(json, ['date']),
      supplier: code == null || code.isEmpty ? name : '$code - $name',
      service: pickString(json, ['service_name', 'service']),
      site: pickString(json, ['site_name', 'site']),
      paymentMode: pickString(json, ['payment_mode_name']),
      deliveryDate: pickString(json, ['delivery_date']),
      totalTtc: pickDouble(json, ['total_ttc']),
      status: DocStatus.fromCode(pickInt(json, ['status_code'], fallback: -1)),
      statusLabel: pickString(json, ['status_label', 'status_name']),
      createdBy: pickString(json, ['created_by_name', 'created_by']),
      products: asMapList(json['products']).map(DocumentProduct.fromJson).toList(),
    );
  }
}

/// Demande de paiement — `/api/payment-requests` (read-only in the app).
class PaymentRequest {
  const PaymentRequest({
    required this.id,
    required this.reference,
    required this.date,
    required this.supplier,
    required this.status,
    required this.statusLabel,
    required this.createdBy,
    required this.amount,
    required this.observation,
    this.operations = const [],
  });

  final int id;
  final String reference;
  final String date;
  final String supplier;
  final DocStatus status;
  final String statusLabel;
  final String createdBy;
  final double amount;
  final String observation;
  final List<PaymentOperation> operations;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    final code = pickStringOrNull(json, ['supplier_code']);
    final name = pickString(json, ['supplier_name']).replaceAll(RegExp(r'\s+'), ' ').trim();
    return PaymentRequest(
      id: pickInt(json, ['id']),
      reference: pickString(json, ['reference']),
      date: pickString(json, ['date']),
      supplier: code == null || code.isEmpty ? name : '$code - $name',
      status: DocStatus.fromCode(pickInt(json, ['status_code'], fallback: -1)),
      statusLabel: pickString(json, ['status_label', 'status_name']),
      createdBy: pickString(json, ['created_by_name', 'created_by']),
      amount: pickDouble(json, ['amount']),
      observation: pickString(json, ['observation']),
      // List payload sends `operations` as a <br>-joined object; only the detail sends rows.
      operations: asMapList(json['operations']).map(PaymentOperation.fromJson).toList(),
    );
  }
}

class PaymentOperation {
  const PaymentOperation({
    required this.reference,
    required this.mode,
    required this.type,
    required this.amount,
    required this.invoice,
  });

  final String reference;
  final String mode;
  final String type;
  final double amount;
  final String invoice;

  factory PaymentOperation.fromJson(Map<String, dynamic> json) => PaymentOperation(
        reference: pickString(json, ['code']),
        mode: pickString(json, ['mode_name']),
        type: pickString(json, ['type_name']),
        amount: pickDouble(json, ['amount', 'ttc']),
        invoice: pickString(json, ['code_file']),
      );
}

/// Product row of a demande d'achat or bon de commande.
class DocumentProduct {
  const DocumentProduct({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.processed,
    required this.remaining,
    required this.unitPrice,
    this.neededAt,
  });

  final String name;
  final String unit;

  /// Quantité demandée (DA) / commandée (BC).
  final double quantity;

  /// Quantité commandée (DA) / livrée (BC).
  final double processed;
  final double remaining;
  final double unitPrice;

  /// DA only — "Date besoin" lives on each product row, not on the header.
  final String? neededAt;

  // Keys verified against demo.smartvision-dz.com on 21/09/2026:
  // DA rows → quantity / quantity_cmn / quantity_cmn_rest / date_needed,
  // BC rows → quantity / quantity_liv / rest_quantity / price.
  factory DocumentProduct.fromJson(Map<String, dynamic> json) {
    final quantity = pickDouble(json, ['quantity']);
    final processed = pickDouble(json, ['quantity_cmn', 'quantity_liv']);
    return DocumentProduct(
      name: pickString(json, ['product_name', 'designation']).trim().replaceAll(RegExp(r'\s*-\s*$'), ''),
      unit: pickString(json, ['unit_name', 'um'], fallback: 'U'),
      quantity: quantity,
      processed: processed,
      remaining: pickDouble(json, ['quantity_cmn_rest', 'rest_quantity'], fallback: quantity - processed),
      unitPrice: pickDouble(json, ['price', 'fprice']),
      neededAt: pickStringOrNull(json, ['date_needed']),
    );
  }
}

/// Retrait (décaissement) — `/api/retraits`.
class Retrait {
  const Retrait({
    required this.id,
    required this.reference,
    required this.date,
    required this.time,
    required this.amount,
    required this.treasury,
    required this.partner,
    required this.category,
    required this.chargeAccount,
    required this.imputationAccount,
    required this.designation,
  });

  final int id;
  final String reference;
  final String date;
  final String time;
  final double amount;
  final String treasury;
  final String partner;
  final String category;
  final String chargeAccount;
  final String? imputationAccount;
  final String designation;

  factory Retrait.fromJson(Map<String, dynamic> json) => Retrait(
        id: pickInt(json, ['id']),
        reference: pickString(json, ['reference', 'code']),
        date: pickString(json, ['date']),
        time: pickString(json, ['time']),
        amount: pickDouble(json, ['amount', 'montant']),
        treasury: pickString(json, ['treasury_name', 'treasury_code']).replaceAll(RegExp(r'\s+'), ' ').trim(),
        partner: pickString(json, ['partner_name']),
        category: pickString(json, ['cashout_category_label', 'cashout_category_name']),
        chargeAccount: _account(json, 'charge_account'),
        imputationAccount: pickStringOrNull(json, ['imputation_account_label', 'imputation_account_name']),
        designation: pickString(json, ['designation']),
      );

  /// "63110 – Traitements et Salaires" when both parts are present.
  static String _account(Map<String, dynamic> json, String prefix) {
    final name = pickString(json, ['${prefix}_name']);
    final label = pickString(json, ['${prefix}_label']);
    if (name.isEmpty || label.isEmpty || name == label) return name.isEmpty ? label : name;
    return '$name – $label';
  }
}
