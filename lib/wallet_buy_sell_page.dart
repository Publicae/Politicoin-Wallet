import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/stores/wallet_buy_sell_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WalletBuySellPage extends StatefulWidget {
  WalletBuySellPage(this.store, {Key key, this.title}) : super(key: key);

  final WalletBuySellStore store;
  final String title;

  @override
  _WalletBuySellPageState createState() => _WalletBuySellPageState();
}

class _WalletBuySellPageState extends State<WalletBuySellPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.reset();
    _popForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Observer(
        builder: (_) {
          return PaperForm(
            padding: 50,
            children: <Widget>[
              PaperValidationSummary(widget.store.errors),
              PaperInput(
                controller: _amountController,
                labelText: 'Amount',
                hintText: 'PBLC',
                onChanged: widget.store.setAmount,
              ),
              Container( margin: EdgeInsets.all(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Buy PBLC'),
                    onPressed: !widget.store.loading
                        ? () {
                            widget.store.buy().listen((tx) {
                              Navigator.pop(context);
                              switch (tx.status) {
                                case TransactionStatus.started:
                                  Navigator.pushNamed(
                                      context, '/transactions');
                                  break;
                                case TransactionStatus.confirmed:
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/'));
                                  break;
                              }
                            }).onError((error) =>
                                widget.store.setError(error.message));
                          }
                        : null,
                  ),
                  RaisedButton(
                    child: const Text('Sell PBLC'),
                    onPressed: !widget.store.loading
                        ? () {
                            widget.store.sell().listen((tx) {
                              switch (tx.status) {
                                case TransactionStatus.started:
                                  Navigator.pushNamed(
                                      context, '/transactions');
                                  break;
                                case TransactionStatus.confirmed:
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/'));
                                  break;
                              }
                            }).onError((error) =>
                                widget.store.setError(error.message));
                          }
                        : null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _popForm() {
    _amountController.value = TextEditingValue(text: widget.store.amount ?? "");
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
