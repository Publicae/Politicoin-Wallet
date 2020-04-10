import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';

import 'components/wallet/transaction_list.dart';

class WalletTransactionsPage extends StatefulWidget {
  WalletTransactionsPage(this.store, {Key key, this.title}) : super(key: key);

  final WalletTransactionsStore store;
  final String title;

  @override
  _WalletTransactionsPageState createState() => _WalletTransactionsPageState();
}

class _WalletTransactionsPageState extends State<WalletTransactionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final String hash = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return Center(
      child: TransactionList(widget.store),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("INFO: cancelling timer");
    widget.store.timer.cancel();
  }
}
