// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_buy_sell_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletBuySellStore on WalletBuySellStoreBase, Store {
  final _$amountAtom = Atom(name: 'WalletBuySellStoreBase.amount');

  @override
  String get amount {
    _$amountAtom.context.enforceReadPolicy(_$amountAtom);
    _$amountAtom.reportObserved();
    return super.amount;
  }

  @override
  set amount(String value) {
    _$amountAtom.context.conditionallyRunInAction(() {
      super.amount = value;
      _$amountAtom.reportChanged();
    }, _$amountAtom, name: '${_$amountAtom.name}_set');
  }

  final _$errorsAtom = Atom(name: 'WalletBuySellStoreBase.errors');

  @override
  ObservableList<String> get errors {
    _$errorsAtom.context.enforceReadPolicy(_$errorsAtom);
    _$errorsAtom.reportObserved();
    return super.errors;
  }

  @override
  set errors(ObservableList<String> value) {
    _$errorsAtom.context.conditionallyRunInAction(() {
      super.errors = value;
      _$errorsAtom.reportChanged();
    }, _$errorsAtom, name: '${_$errorsAtom.name}_set');
  }

  final _$loadingAtom = Atom(name: 'WalletBuySellStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$WalletBuySellStoreBaseActionController =
      ActionController(name: 'WalletBuySellStoreBase');

  @override
  void setAmount(String value) {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.setAmount(value);
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void isLoading(bool value) {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.isLoading(value);
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.reset();
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String message) {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.setError(message);
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Stream<Transaction> buy() {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.buy();
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Stream<Transaction> sell() {
    final _$actionInfo = _$WalletBuySellStoreBaseActionController.startAction();
    try {
      return super.sell();
    } finally {
      _$WalletBuySellStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'amount: ${amount.toString()},errors: ${errors.toString()},loading: ${loading.toString()}';
    return '{$string}';
  }
}
