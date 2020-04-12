import 'package:flushbar/flushbar.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/transactions', arguments: "");
            },
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) => buildForm(ctx),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
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
              Container(margin: EdgeInsets.all(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Buy PBLC'),
                    onPressed: !widget.store.loading
                        ? () {
                            widget.store.buy().listen((tx) {
                              //Navigator.pop(context);
                              switch (tx.status) {
                                case TransactionStatus.started:
                                  print('transact pending ${tx.key}');
                                  //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
                                  showInfoFlushbar(context, true, tx.key);
                                  break;
                                case TransactionStatus.confirmed:
                                  print('transact confirmed ${tx.key}');
                                  //Navigator.popUntil(context, ModalRoute.withName('/'));
                                  showInfoFlushbar(context, false, tx.key);
                                  break;
                                default:
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
                                  print('transact pending ${tx.key}');
                                  showInfoFlushbar(context, true, tx.key);
                                  //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
                                  break;
                                case TransactionStatus.confirmed:
                                  print('transact confirmed ${tx.key}');
                                  showInfoFlushbar(context, false, tx.key);
                                  //Navigator.popUntil(context, ModalRoute.withName('/'));
                                  break;
                                default:
                                  break;
                              }
                            }).onError((error) =>
                                widget.store.setError(error.message));
                          }
                        : null,
                  ),
                ],
              ),
              Divider(),
              Text(
                'Buy or sell PBLC tokens from the Politicoin contract.',
                style: TextStyle(color: Colors.red),
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

  void showInfoFlushbar(BuildContext context, bool pending, String hash) {
    widget.store.loading = false;
    Flushbar(
      title: pending ? 'Transaction Pending' : 'Transaction Confirmed',
      message: '$hash',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
