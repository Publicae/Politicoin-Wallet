import 'dart:async';
import 'dart:math';
import 'package:pblcwallet/components/buttons/copy_button.dart';
import 'package:pblcwallet/model/transactionsModel.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.store);

  final WalletTransactionsStore store;
  final streamController = StreamController<List<TransactionModel>>();
  final interval = const Duration(seconds:25);

  @override
  Widget build(BuildContext context) {

    if (store.timer == null) {
      store.timer = Timer.periodic(interval, (Timer t) => _fetchTransactions(context));
    }

    return StreamBuilder<List<TransactionModel>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TransactionModel> data = snapshot.data;
          if(data.isEmpty) {
            return Text("No transactions available!");
          }
          return _transactionsListView(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          _fetchTransactions(context);
        }
        return CircularProgressIndicator();
      },
    );
  }

  _fetchTransactions(BuildContext context) async {
    print("fetching transactions...");
    try {
      await store.fetchTransactions(context);
      streamController.add(store.transactionsModel.transactions);
    } catch(ex) {
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
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _tile(data[index]);
          }),
      onRefresh: () async {
        await _fetchTransactions(context);
      },
    );
  }

  Center _tile(TransactionModel transaction) => Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title:
                    Text('${transaction.hash}', style: TextStyle(fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('blockNumber: ${transaction.blockNumber}'),
                    Text('amount: ${showAmount(transaction.value)}'),
                    Text('from: ${transaction.from}'),
                    Text('to: ${transaction.to}'),
                    Text('${transaction.formattedDate()}')
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(transaction.txreceiptStatus == ""
                      ? "pending"
                      : "confirmed"),
                  Text(transaction.to == store.walletStore.address
                      ? "RECEIVED"
                      : "SENT")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CopyButton(
                    text: const Text('Copy From'),
                    value: transaction.from,
                  ),
                  CopyButton(
                    text: const Text('Copy To'),
                    value: transaction.to,
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
