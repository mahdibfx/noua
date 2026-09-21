import 'package:flutter_test/flutter_test.dart';
import 'package:noua/utils/formatters.dart';

void main() {
  test('formatters match the maquette', () {
    expect(formatDa(41650), '41 650.00 DA');
    expect(formatDa(72590000), '72 590 000.00 DA');
    expect(formatDa(4250000, round: true), '4 250 000 DA');
    expect(formatQty(1200, 'U'), '1 200 U');
    expect(formatQty(0, 'U'), '0 U');
    expect(formatDate(DateTime(2026, 9, 4)), '04/09/2026');
  });
}
