import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/credentials.dart';

part 'wallet_transfer_store.g.dart';

class WalletTransferStore = WalletTransferStoreBase with _$WalletTransferStore;

abstract class WalletTransferStoreBase with Store {
  WalletTransferStoreBase(this.walletStore, this._contractService);

  final WalletStore walletStore;
  final IContractService _contractService;

  @observable
  String to;
  @observable
  String amount;
  @observable
  ObservableList<String> errors = ObservableList<String>();
  @observable
  bool loading;
  
  @observable
  String ethGasPrice;

  @action
  void setTo(String value) {
      this.to = value;
  }

  @action
  void setAmount(String value) {
    if (value == "") {
      this.errors.clear();
      this.loading = true;
    } else {
      if(double.tryParse(value) != null) {
        this.loading = false;
        this.amount = value;
      } else {
        this.errors.clear();
        this.loading = true;
        this.errors.add("Amount error: enter a numeric value");
      }
    }
  }

  @action
  void isLoading(bool value) {
    this.loading = value;
  }

  @action
  void reset() {
    this.to = "";
    this.amount = "";
    this.loading = true;
    this.errors.clear();
  }

  @action
  void setError(String message) {
    isLoading(false);

    this.errors.clear();
    this.errors.add(message);
  }

  @action
  Stream<Transaction> transfer() {
    var controller = StreamController<Transaction>();
    var transactionEvent = Transaction();

    isLoading(true);

    // PBLC is 9 decimals. 1 PBLC = 0,000,000,001 ETH
    var amount = double.parse(this.amount) * pow(10, 9);
    try {
      EthereumAddress.fromHex(this.to);
    } catch (ex) {
      this.errors.add("Address format error: ${ex.message}");
      return null;
    }

    _contractService.send(
        walletStore.privateKey,
        EthereumAddress.fromHex(this.to),
        BigInt.from(amount),
        onTransfer: (from, to, value) {
          controller.add(transactionEvent.confirmed(from, to, value));
          controller.close();
          isLoading(false);
        },
        onError: (ex) {
          controller.addError(ex);
          isLoading(false);
        })
        .then((id) => {if (id != null) controller.add(transactionEvent.setId(id))});

    return controller.stream;
  }

  @action
  void transferEth(BuildContext context) {

    // Amount we put in the textfield is in wei
    // If we want it to be ether
    // BigInt.from(double.parse(this.amount) * pow(10, 18))
    var amount = double.parse(this.amount);

    _contractService.sendEth(
        walletStore.privateKey,
        EthereumAddress.fromHex(this.to),
        BigInt.from(amount))
    .then((id) {
      print("Transaction ETH pending: $id");
      //Navigator.pushNamed(context, '/transactions');
    });
  }

  @action
  Future getEthGasPrice() async {
    await _contractService.getEthGasPrice()
    .then((amnt) => this.ethGasPrice = amnt.getInWei.toString());
  }
}
