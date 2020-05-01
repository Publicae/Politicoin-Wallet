import 'dart:async';
import 'dart:math';
import 'package:pblcwallet/components/transactions/transaction_item.dart';
import 'package:pblcwallet/model/transactionsModel.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.store);

  final WalletTransactionsStore store;
  final streamController = StreamController<List<TransactionModel>>();
  final interval = const Duration(seconds: 25);

  @override
  Widget build(BuildContext context) {
    if (store.timer == null) {
      store.timer =
          Timer.periodic(interval, (Timer t) => _fetchTransactions(context));
    }

    return StreamBuilder<List<TransactionModel>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TransactionModel> data = snapshot.data;
          if (data.isEmpty) {
            return Text("No transactions available!");
          }
          return _transactionsListView(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          _fetchTransactions(context);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _fetchTransactions(BuildContext context) async {
    print("fetching transactions...");
    try {
      await store.fetchTransactions(context);
      streamController.add(store.transactionsModel.transactions);
    } catch (ex) {
      print("ERROR: ${ex.toString()}");
      store.timer.cancel();
      store.timer = null;
    }
  }

  String showAmount(String value) {
    var ethValue = int.parse(value) / pow(10, 18);
    return '$value wei / $ethValue ETH';
  }

  RefreshIndicator _transactionsListView(BuildContext context, data) {
    return RefreshIndicator(
      child: Container(
        //color: Colors.red,
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Color(0xfff6f6f6),
              ),
              child: ListTile(
                title: Text(
                  'Tap on a transaction address below, to visit Etherscan for more details',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                leading: Icon(Icons.info),
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _tile(context, data[index]);
                }),
          ],
        ),
      ),
      onRefresh: () async {
        await _fetchTransactions(context);
      },
    );
  }

  Center _tile(BuildContext context, TransactionModel transaction) => Center(
        child: TransactionItem(store, transaction),
      );
}
