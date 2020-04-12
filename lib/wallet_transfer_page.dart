import 'package:flushbar/flushbar.dart';
import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WalletTransferPage extends StatefulWidget {
  WalletTransferPage(this.store, {Key key, this.title}) : super(key: key);

  final WalletTransferStore store;
  final String title;

  @override
  _WalletTransferPageState createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage> {
  final TextEditingController _toController = TextEditingController();
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
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.of(context).pushNamed("/qrcode_reader",
                  arguments: (ethAddress) async {
                widget.store.setTo(ethAddress);
                _popForm();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/transactions',
                  arguments: "");
            },
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) => buildForm(),
      ),
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
                controller: _toController,
                labelText: 'To',
                hintText: 'Type the destination address',
                onChanged: widget.store.setTo,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: PaperInput(
                      controller: _amountController,
                      labelText: 'Amount',
                      hintText: '0',
                      onChanged: widget.store.setAmount,
                    ),
                  ),
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem<String>(
                        child: Text('PBLC'),
                        value: 'PBLC',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('wei'),
                        value: 'wei',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('gwei (Shannon)'),
                        value: 'gwei',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('pwei (Finney)'),
                        value: 'pwei',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('ether (Buterin)'),
                        value: 'ether',
                      ),
                    ],
                    onChanged: (String value) {
                      widget.store.denomination = value;
                    },
                    hint: Text("PBLC"),
                    value: widget.store.denomination ?? "PBLC",
                  ),
                ],
              ),
              Container(margin: EdgeInsets.all(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Transfer PBLC'),
                    onPressed: !widget.store.loading &&
                            widget.store.denomination == "PBLC"
                        ? () {
                            widget.store.transfer().listen((tx) {
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
                  RaisedButton(
                    child: const Text('Transfer ETH'),
                    onPressed: !widget.store.loading &&
                            widget.store.denomination != "PBLC"
                        ? () {
                            showInfoFlushbar(
                                context, true, "actual ETH transaction");
                            widget.store.transferEth(context);
                          }
                        : null,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     RaisedButton(
                  //       child: const Text('get gas price'),
                  //       onPressed: !widget.store.loading
                  //           ? () => widget.store.getEthGasPrice()
                  //           : null,
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     PaperGasPrice(_getEthGasPrice()),
                  //   ],
                  // )
                ],
              ),
              Divider(),
              Text(
                'When transfering PBLC, make sure the receiving address has a PBLC compliant wallet!',
                style: TextStyle(color: Colors.red),
              ),
              Divider(),
              Text("1 Ether = 1,000,000,000,000,000,000 wei"),
            ],
          );
        },
      ),
    );
  }

  void _popForm() {
    _toController.value = TextEditingValue(text: widget.store.to ?? "");
    _amountController.value = TextEditingValue(text: widget.store.amount ?? "");
  }

  // String _getEthGasPrice() {
  //   var price = widget.store.ethGasPrice ?? "";
  //   return price;
  // }

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
    _toController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
