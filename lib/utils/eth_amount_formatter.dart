import 'dart:math';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';

class EthAmountFormatter {
  EthAmountFormatter(this.amount);

  final BigInt amount;

  String format({
    fromUnit = EtherUnit.wei,
    toUnit = EtherUnit.ether,
  }) {
    if (amount == null) return "-";

    final res =
        EtherAmount.fromUnitAndValue(fromUnit, amount).getValueInUnit(toUnit);
    final withFormat = formatted(res);

    return withFormat;
  }

  // print("1000200".replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},"));

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String formatted(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 9);
  }
}
