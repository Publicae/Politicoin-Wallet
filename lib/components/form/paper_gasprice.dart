import 'package:flutter/cupertino.dart';

class PaperGasPrice extends StatelessWidget {
  PaperGasPrice(this.ethGasPrice);
  final String ethGasPrice;

  @override
  Widget build(BuildContext context) {
    return Text(ethGasPrice);
  }
}