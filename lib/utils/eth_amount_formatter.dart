import 'dart:math';
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
    return roundDouble(res, 9).toString();
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
