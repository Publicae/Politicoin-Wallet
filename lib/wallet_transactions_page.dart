import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return Center(
      child: Observer(
        builder: (_) => TransactionList(widget.store),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
