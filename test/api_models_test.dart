import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noua/models/manager_models.dart';

/// Fixtures are real responses from demo.smartvision-dz.com (21/09/2026).
Map<String, dynamic> _data(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync())['data'] as Map<String, dynamic>;

void main() {
  test('demande d\'achat detail', () {
    final r = PurchaseRequest.fromJson(_data('purchase_request_detail'));
    expect(r.id, 30);
    expect(r.reference, 'DA00030/2026');
    expect(r.requester, 'WALID CHEKHAB');
    expect(r.beb, 'BEB00029/2026');
    expect(r.priority, 3);
    expect(r.status, DocStatus.enCours);
    final p = r.products.single;
    expect(p.name, 'DEBITMETRE ELECTROMAGNETIQUE COMPACTE');
    expect((p.quantity, p.processed, p.remaining), (1, 1, 0));
    expect(p.unit, 'U');
    expect(p.neededAt, '14/09/2026');
  });

  test('bon de commande detail', () {
    final o = CommandOrder.fromJson(_data('command_order_detail'));
    expect(o.id, 16);
    expect(o.supplier, 'FRS0048 - GENIE HYDRAULIQUE ET HYDROCARBURE');
    expect(o.service, 'MOYENS GENERAUX');
    expect(o.paymentMode, 'A terme');
    expect(o.deliveryDate, '14/09/2026');
    expect(o.totalTtc, 41650);
    expect(o.status, DocStatus.enCours);
    final p = o.products.single;
    expect((p.quantity, p.processed, p.remaining, p.unitPrice), (1, 0, 1, 35000));
  });

  test('demande de paiement detail', () {
    final p = PaymentRequest.fromJson(_data('payment_request_detail'));
    expect(p.amount, 5680584);
    expect(p.status, DocStatus.validee);
    final op = p.operations.single;
    expect((op.reference, op.mode, op.type, op.invoice, op.amount),
        ('REC-MAT00018/2026', 'A terme', 'Achat', '00012', 5680584));
  });

  test('retrait detail', () {
    final r = Retrait.fromJson(_data('retrait_detail'));
    expect(r.id, 60);
    expect(r.reference, 'RETR00060/2026');
    expect(r.amount, 315000);
    expect(r.treasury, "CAISSE BUREAU D'ALGER");
    expect(r.partner, 'EURL KRIKROU');
    expect(r.chargeAccount, '63110 – Traitements et Salaires');
    expect(r.imputationAccount, 'DIRECTION GENERALE');
    expect(r.designation, 'salaire eurl krikrou 09-2026');
  });

  test('dashboard', () {
    final s = DashboardStats.fromJson(_data('dashboard'));
    expect(s.customersBalance, lessThan(0));
    expect(s.pendingOrders, isA<int>());
    expect(s.withdrawals, greaterThan(0));
  });

  test('missing status_code is unknown, not "Réceptionné" (0)', () {
    expect(PurchaseRequest.fromJson({'id': 1}).status, DocStatus.inconnu);
    expect(PurchaseRequest.fromJson({'status_code': 0}).status, DocStatus.receptionne);
  });
}
