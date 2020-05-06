// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on SettingsStoreBase, Store {
  final _$versionAtom = Atom(name: 'SettingsStoreBase.version');

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

  @override
  String toString() {
    final string = 'version: ${version.toString()}';
    return '{$string}';
  }
}
