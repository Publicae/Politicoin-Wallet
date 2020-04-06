import 'dart:async';
import 'dart:math';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:mobx/mobx.dart';

part 'wallet_buy_sell_store.g.dart';

class WalletBuySellStore = WalletBuySellStoreBase with _$WalletBuySellStore;

abstract class WalletBuySellStoreBase with Store {
  WalletBuySellStoreBase(this.walletStore, this._contractService);

  final WalletStore walletStore;
  final IContractService _contractService;

  @observable
  String amount;
  
  @observable
  ObservableList<String> errors = ObservableList<String>();
  
  @observable
  bool loading;

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
  Stream<Transaction> buy() {
    var controller = StreamController<Transaction>();
    var transactionEvent = Transaction();

    isLoading(true);

    // PBLC is 9 decimals. 1 PBLC = 0,000,000,001 ETH
    // The amount we put in is in unit for 1 PBLC,
    // so if we put 1 we mean 1.000.000.000 wei
    var amount = double.tryParse(this.amount) * pow(10, 9);

    _contractService.buy(
        walletStore.privateKey,
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
  Stream<Transaction> sell() {
    var controller = StreamController<Transaction>();
    var transactionEvent = Transaction();

    isLoading(true);

    // PBLC is 9 decimals. 1 PBLC = 0,000,000,001 ETH
    // The amount we put in is in unit for 1 PBLC, 
    // so if we put 1 we mean 1.000.000.000 wei
    var amount = double.parse(this.amount) * pow(10, 9);

    _contractService.sell(
        walletStore.privateKey,
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
}
