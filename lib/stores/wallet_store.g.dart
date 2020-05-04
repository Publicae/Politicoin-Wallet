// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on WalletStoreBase, Store {
  final _$tokenBalanceAtom = Atom(name: 'WalletStoreBase.tokenBalance');

  @override
  BigInt get tokenBalance {
    _$tokenBalanceAtom.context.enforceReadPolicy(_$tokenBalanceAtom);
    _$tokenBalanceAtom.reportObserved();
    return super.tokenBalance;
  }

  @override
  set tokenBalance(BigInt value) {
    _$tokenBalanceAtom.context.conditionallyRunInAction(() {
      super.tokenBalance = value;
      _$tokenBalanceAtom.reportChanged();
    }, _$tokenBalanceAtom, name: '${_$tokenBalanceAtom.name}_set');
  }

  final _$ethBalanceAtom = Atom(name: 'WalletStoreBase.ethBalance');

  @override
  BigInt get ethBalance {
    _$ethBalanceAtom.context.enforceReadPolicy(_$ethBalanceAtom);
    _$ethBalanceAtom.reportObserved();
    return super.ethBalance;
  }

  @override
  set ethBalance(BigInt value) {
    _$ethBalanceAtom.context.conditionallyRunInAction(() {
      super.ethBalance = value;
      _$ethBalanceAtom.reportChanged();
    }, _$ethBalanceAtom, name: '${_$ethBalanceAtom.name}_set');
  }

  final _$ethGasPriceAtom = Atom(name: 'WalletStoreBase.ethGasPrice');

  @override
  BigInt get ethGasPrice {
    _$ethGasPriceAtom.context.enforceReadPolicy(_$ethGasPriceAtom);
    _$ethGasPriceAtom.reportObserved();
    return super.ethGasPrice;
  }

  @override
  set ethGasPrice(BigInt value) {
    _$ethGasPriceAtom.context.conditionallyRunInAction(() {
      super.ethGasPrice = value;
      _$ethGasPriceAtom.reportChanged();
    }, _$ethGasPriceAtom, name: '${_$ethGasPriceAtom.name}_set');
  }

  final _$addressAtom = Atom(name: 'WalletStoreBase.address');

  @override
  String get address {
    _$addressAtom.context.enforceReadPolicy(_$addressAtom);
    _$addressAtom.reportObserved();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.context.conditionallyRunInAction(() {
      super.address = value;
      _$addressAtom.reportChanged();
    }, _$addressAtom, name: '${_$addressAtom.name}_set');
  }

  final _$privateKeyAtom = Atom(name: 'WalletStoreBase.privateKey');

  @override
  String get privateKey {
    _$privateKeyAtom.context.enforceReadPolicy(_$privateKeyAtom);
    _$privateKeyAtom.reportObserved();
    return super.privateKey;
  }

  @override
  set privateKey(String value) {
    _$privateKeyAtom.context.conditionallyRunInAction(() {
      super.privateKey = value;
      _$privateKeyAtom.reportChanged();
    }, _$privateKeyAtom, name: '${_$privateKeyAtom.name}_set');
  }

  final _$transactionsAtom = Atom(name: 'WalletStoreBase.transactions');

  @override
  ObservableList<Transaction> get transactions {
    _$transactionsAtom.context.enforceReadPolicy(_$transactionsAtom);
    _$transactionsAtom.reportObserved();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<Transaction> value) {
    _$transactionsAtom.context.conditionallyRunInAction(() {
      super.transactions = value;
      _$transactionsAtom.reportChanged();
    }, _$transactionsAtom, name: '${_$transactionsAtom.name}_set');
  }

  final _$usernameAtom = Atom(name: 'WalletStoreBase.username');

  @override
  String get username {
    _$usernameAtom.context.enforceReadPolicy(_$usernameAtom);
    _$usernameAtom.reportObserved();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.context.conditionallyRunInAction(() {
      super.username = value;
      _$usernameAtom.reportChanged();
    }, _$usernameAtom, name: '${_$usernameAtom.name}_set');
  }

  final _$versionAtom = Atom(name: 'WalletStoreBase.version');

  @override
  String get version {
    _$versionAtom.context.enforceReadPolicy(_$versionAtom);
    _$versionAtom.reportObserved();
    return super.version;
  }

  @override
  set version(String value) {
    _$versionAtom.context.conditionallyRunInAction(() {
      super.version = value;
      _$versionAtom.reportChanged();
    }, _$versionAtom, name: '${_$versionAtom.name}_set');
  }

  final _$initialiseAsyncAction = AsyncAction('initialise');

  @override
  Future<void> initialise() {
    return _$initialiseAsyncAction.run(() => super.initialise());
  }

  final _$fetchOwnBalanceAsyncAction = AsyncAction('fetchOwnBalance');

  @override
  Future<void> fetchOwnBalance() {
    return _$fetchOwnBalanceAsyncAction.run(() => super.fetchOwnBalance());
  }

  final _$resetWalletAsyncAction = AsyncAction('resetWallet');

  @override
  Future<void> resetWallet() {
    return _$resetWalletAsyncAction.run(() => super.resetWallet());
  }

  final _$fetchEthGasPriceAsyncAction = AsyncAction('fetchEthGasPrice');

  @override
  Future<void> fetchEthGasPrice() {
    return _$fetchEthGasPriceAsyncAction.run(() => super.fetchEthGasPrice());
  }

  final _$getUserInfoAsyncAction = AsyncAction('getUserInfo');

  @override
  Future<dynamic> getUserInfo(BuildContext context) {
    return _$getUserInfoAsyncAction.run(() => super.getUserInfo(context));
  }

  final _$signOutAsyncAction = AsyncAction('signOut');

  @override
  Future<dynamic> signOut(BuildContext context) {
    return _$signOutAsyncAction.run(() => super.signOut(context));
  }

  final _$deleteUserAsyncAction = AsyncAction('deleteUser');

  @override
  Future<dynamic> deleteUser(BuildContext context) {
    return _$deleteUserAsyncAction.run(() => super.deleteUser(context));
  }

  final _$WalletStoreBaseActionController =
      ActionController(name: 'WalletStoreBase');

  @override
  Stream<Transaction> transfer() {
    final _$actionInfo = _$WalletStoreBaseActionController.startAction();
    try {
      return super.transfer();
    } finally {
      _$WalletStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'tokenBalance: ${tokenBalance.toString()},ethBalance: ${ethBalance.toString()},ethGasPrice: ${ethGasPrice.toString()},address: ${address.toString()},privateKey: ${privateKey.toString()},transactions: ${transactions.toString()},username: ${username.toString()},version: ${version.toString()}';
    return '{$string}';
  }
}
