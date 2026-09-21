import 'package:intl/intl.dart';

final _amount = NumberFormat('#,##0.00', 'en_US');
final _amountRound = NumberFormat('#,##0', 'en_US');
final _qty = NumberFormat('#,##0.##', 'en_US');
final _date = DateFormat('dd/MM/yyyy');

/// 41650 → "41 650.00 DA" ; round: true → "41 650 DA"
String formatDa(double value, {bool round = false}) =>
    '${(round ? _amountRound : _amount).format(value).replaceAll(',', ' ')} DA';

String formatDate(DateTime date) => _date.format(date);

/// 1200 + 'U' → "1 200 U"
String formatQty(double value, String unit) => '${_qty.format(value).replaceAll(',', ' ')} $unit';

/// 2026-09-16 — the format the API expects for date_from / date_to.
String formatApiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
