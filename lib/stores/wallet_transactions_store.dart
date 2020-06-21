import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:pblcwallet/api_keys.dart';
import 'package:pblcwallet/data/fetchEtherscanData.dart';
import 'package:pblcwallet/model/transactionsModel.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'wallet_transactions_store.g.dart';

class WalletTransactionsStore = WalletTransactionsStoreBase with _$WalletTransactionsStore;

abstract class WalletTransactionsStoreBase with Store {
  WalletTransactionsStoreBase(this.walletStore);

  final WalletStore walletStore;
  Timer timer;

  @observable
  TransactionsModel transactionsModel = TransactionsModel();

  @action
  Future<void> refresh(BuildContext context) async {
    await fetchTransactions(context);
  }

  @action
  Future fetchTransactions(BuildContext context) async {
    final etherscanData = Provider.of<FetchEtherscanData>(context);
    final response = await etherscanData.fetchData(walletStore.address, ApiKeys.etherscanApiKey);
    transactionsModel = transactionsModelFromJson(response.bodyString);
  }
}
