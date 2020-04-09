// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transactions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletTransactionsStore on WalletTransactionsStoreBase, Store {
  final _$transactionsModelAtom =
      Atom(name: 'WalletTransactionsStoreBase.transactionsModel');

  @override
  TransactionsModel get transactionsModel {
    _$transactionsModelAtom.context.enforceReadPolicy(_$transactionsModelAtom);
    _$transactionsModelAtom.reportObserved();
    return super.transactionsModel;
  }

  @override
  set transactionsModel(TransactionsModel value) {
    _$transactionsModelAtom.context.conditionallyRunInAction(() {
      super.transactionsModel = value;
      _$transactionsModelAtom.reportChanged();
    }, _$transactionsModelAtom, name: '${_$transactionsModelAtom.name}_set');
  }

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<void> refresh(BuildContext context) {
    return _$refreshAsyncAction.run(() => super.refresh(context));
  }

  final _$fetchTransactionsAsyncAction = AsyncAction('fetchTransactions');

  @override
  Future<dynamic> fetchTransactions(BuildContext context) {
    return _$fetchTransactionsAsyncAction
        .run(() => super.fetchTransactions(context));
  }

  @override
  String toString() {
    final string = 'transactionsModel: ${transactionsModel.toString()}';
    return '{$string}';
  }
}
