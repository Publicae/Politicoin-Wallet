import 'package:flushbar/flushbar.dart';
import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/stores/wallet_buy_sell_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pblcwallet/utils/eth_amount_formatter.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/back.png"),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: ImageIcon(
              AssetImage("assets/images/transactions.png"),
            ),
            onPressed: () {
              Navigator.popAndPushNamed(
                context,
                '/transactions',
                arguments: "",
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Builder(
          builder: (ctx) => buildForm(ctx),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bkg1.png"),
                fit: BoxFit.fill,
              ),
            ),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            child: null,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bkg2.png"),
                fit: BoxFit.cover,
              ),
              // border: Border.all(),
            ),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    "Available Balance",
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      "PBLC",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Observer(
                      builder: (_) => Text(
                        "${EthAmountFormatter(widget.store.walletStore.tokenBalance).format()}",
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .apply(fontSizeDelta: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Observer(
                      builder: (_) => Text(
                        "${EthAmountFormatter(widget.store.walletStore.ethBalance).format()} ETH",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            child: Observer(
              builder: (_) {
                return PaperForm(
                  padding: 20,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Please fill in the form below to buy or sell PBLC",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Color(0xff515151),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: PaperInput(
                            controller: _amountController,
                            labelText: 'Amount',
                            hintText: '0',
                            filled: true,
                            fillColor: Colors.white,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff515151),
                            ),
                            onChanged: widget.store.setAmount,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    PaperValidationSummary(widget.store.errors),
                    Opacity(
                      opacity: !widget.store.loading ? 1.0 : 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage("assets/images/bkg5.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Opacity(
                          opacity: !widget.store.loading ? 1.0 : 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: const Text(
                                  'Buy PBLC',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: !widget.store.loading
                                    ? () {
                                        widget.store.buy().listen((tx) {
                                          //Navigator.pop(context);
                                          switch (tx.status) {
                                            case TransactionStatus.started:
                                              print(
                                                  'transact pending ${tx.key}');
                                              //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
                                              showInfoFlushbar(
                                                  context, true, tx.key);
                                              break;
                                            case TransactionStatus.confirmed:
                                              print(
                                                  'transact confirmed ${tx.key}');
                                              //Navigator.popUntil(context, ModalRoute.withName('/'));
                                              showInfoFlushbar(
                                                  context, false, tx.key);
                                              break;
                                            default:
                                              break;
                                          }
                                        }).onError((error) => widget.store
                                            .setError(error.message));
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Opacity(
                      opacity: !widget.store.loading ? 1.0 : 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage("assets/images/bkg5.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Opacity(
                          opacity: !widget.store.loading ? 1.0 : 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: const Text(
                                  'Sell PBLC',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: !widget.store.loading
                                    ? () {
                                        widget.store.sell().listen((tx) {
                                          switch (tx.status) {
                                            case TransactionStatus.started:
                                              print(
                                                  'transact pending ${tx.key}');
                                              showInfoFlushbar(
                                                  context, true, tx.key);
                                              //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
                                              break;
                                            case TransactionStatus.confirmed:
                                              print(
                                                  'transact confirmed ${tx.key}');
                                              showInfoFlushbar(
                                                  context, false, tx.key);
                                              //Navigator.popUntil(context, ModalRoute.withName('/'));
                                              break;
                                            default:
                                              break;
                                          }
                                        }).onError((error) => widget.store
                                            .setError(error.message));
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // Widget buildForm(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Observer(
  //       builder: (_) {
  //         return PaperForm(
  //           padding: 50,
  //           children: <Widget>[
  //             PaperValidationSummary(widget.store.errors),
  //             PaperInput(
  //               controller: _amountController,
  //               labelText: 'Amount',
  //               hintText: 'PBLC',
  //               onChanged: widget.store.setAmount,
  //             ),
  //             Container(margin: EdgeInsets.all(15)),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 RaisedButton(
  //                   child: const Text('Buy PBLC'),
  // onPressed: !widget.store.loading
  //     ? () {
  //         widget.store.buy().listen((tx) {
  //           //Navigator.pop(context);
  //           switch (tx.status) {
  //             case TransactionStatus.started:
  //               print('transact pending ${tx.key}');
  //               //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
  //               showInfoFlushbar(context, true, tx.key);
  //               break;
  //             case TransactionStatus.confirmed:
  //               print('transact confirmed ${tx.key}');
  //               //Navigator.popUntil(context, ModalRoute.withName('/'));
  //               showInfoFlushbar(context, false, tx.key);
  //               break;
  //             default:
  //               break;
  //           }
  //         }).onError((error) =>
  //             widget.store.setError(error.message));
  //       }
  //     : null,
  //                 ),
  //                 RaisedButton(
  //                   child: const Text('Sell PBLC'),
  // onPressed: !widget.store.loading
  //     ? () {
  //         widget.store.sell().listen((tx) {
  //           switch (tx.status) {
  //             case TransactionStatus.started:
  //               print('transact pending ${tx.key}');
  //               showInfoFlushbar(context, true, tx.key);
  //               //Navigator.pushNamed(context, '/transactions', arguments: tx.key);
  //               break;
  //             case TransactionStatus.confirmed:
  //               print('transact confirmed ${tx.key}');
  //               showInfoFlushbar(context, false, tx.key);
  //               //Navigator.popUntil(context, ModalRoute.withName('/'));
  //               break;
  //             default:
  //               break;
  //           }
  //         }).onError((error) =>
  //             widget.store.setError(error.message));
  //       }
  //     : null,
  //                 ),
  //               ],
  //             ),
  //             Divider(),
  //             Text(
  //               'Buy or sell PBLC tokens from the Politicoin contract.',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

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
