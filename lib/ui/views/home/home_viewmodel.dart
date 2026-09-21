import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/models/manager_models.dart';
import 'package:noua/services/manager_service.dart';
import 'package:noua/utils/formatters.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._onOpenTab) {
    _syncControllers();
  }

  final ValueChanged<int> _onOpenTab;
  final _managerService = locator<ManagerService>();
  final _snackbarService = locator<SnackbarService>();

  final fromController = TextEditingController();
  final toController = TextEditingController();

  DashboardPeriod _period = DashboardPeriod.day;
  DateTime _from = DateUtils.dateOnly(DateTime.now());
  DateTime _to = DateUtils.dateOnly(DateTime.now());

  DashboardStats? _stats;
  DashboardStats? get stats => _stats;

  List<String> get periodLabels =>
      ['dashboard.day', 'dashboard.week', 'dashboard.month', 'dashboard.custom'].map((e) => e.tr()).toList();
  int get periodIndex => _period.index;

  Future<void> init() async {
    setBusy(true);
    final result = await _managerService.fetchDashboard(
      dateFrom: formatApiDate(_from),
      dateTo: formatApiDate(_to),
    );
    setBusy(false);
    result.fold(
      (failure) => _snackbarService.showSnackbar(message: failure.message, duration: const Duration(seconds: 3)),
      (stats) => _stats = stats,
    );
  }

  Future<void> onPeriodTap(int index) async {
    _period = DashboardPeriod.values[index];
    final today = DateUtils.dateOnly(DateTime.now());
    switch (_period) {
      case DashboardPeriod.day:
        await _setRange(today, today);
      case DashboardPeriod.week:
        await _setRange(today.subtract(Duration(days: today.weekday - 1)), today);
      case DashboardPeriod.month:
        await _setRange(DateTime(today.year, today.month), today);
      case DashboardPeriod.custom:
        await onFromTap();
    }
  }

  Future<void> onFromTap() => _pickDate(isFrom: true);
  Future<void> onToTap() => _pickDate(isFrom: false);

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: StackedService.navigatorKey!.currentContext!,
      initialDate: isFrom ? _from : _to,
      firstDate: isFrom ? DateTime(2020) : _from,
      lastDate: isFrom ? _to : DateTime.now(),
    );
    if (picked == null) {
      rebuildUi();
      return;
    }
    _period = DashboardPeriod.custom;
    await (isFrom ? _setRange(picked, _to) : _setRange(_from, picked));
  }

  Future<void> _setRange(DateTime from, DateTime to) async {
    _from = from;
    _to = to;
    _syncControllers();
    await init();
  }

  void _syncControllers() {
    fromController.text = formatDate(_from);
    toController.text = formatDate(_to);
  }

  void onPendingPurchasesTap() => _onOpenTab(1);
  void onPendingOrdersTap() => _onOpenTab(2);

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }
}
