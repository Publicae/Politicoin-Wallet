import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:mobx/mobx.dart';
import 'package:pblcwallet/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase with Store {
  WalletStoreBase(
    this._contractService,
    this._addressService,
    this._configurationService,
  );

  final IContractService _contractService;
  final IAddressService _addressService;
  final IConfigurationService _configurationService;

  @observable
  BigInt tokenBalance;

  @observable
  BigInt ethBalance;

  @observable
  BigInt ethGasPrice;

  @observable
  String address;

  @observable
  String privateKey;

  @observable
  ObservableList<Transaction> transactions = ObservableList<Transaction>();

  @observable
  String username = "";

  @observable
  String version = "";

  @action
  Future<void> initialise() async {
    final entropyMnemonic = _configurationService.getMnemonic();
    final privateKey = _configurationService.getPrivateKey();

    if (entropyMnemonic != null && entropyMnemonic.isNotEmpty) {
      _initialiseFromMnemonic(entropyMnemonic);
      return;
    }

    _initialiseFromPrivateKey(privateKey);

    await getVersion();
  }

  Future<void> _initialiseFromMnemonic(String entropyMnemonic) async {
    final mnemonic = _addressService.entropyToMnemonic(entropyMnemonic);
    final privateKey = _addressService.getPrivateKey(mnemonic);
    final address = await _addressService.getPublicAddress(privateKey);

    this.address = address.toString();
    this.privateKey = privateKey;

    await _initialise();
  }

  Future<void> _initialiseFromPrivateKey(String privateKey) async {
    try {
      final address = await _addressService.getPublicAddress(privateKey);

      this.address = address.toString();
      this.privateKey = privateKey;

      await _initialise();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _initialise() async {
    await this.fetchOwnBalance();

    _contractService.listenTransfer((from, to, value) async {
      var fromMe = from.toString() == this.address;
      var toMe = to.toString() == this.address;

      if (!fromMe && !toMe) {
        return;
      }

      await fetchOwnBalance();
    });
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    this.version = "v$version($buildNumber)";
  }

  @action
  Future<void> fetchOwnBalance() async {
    var tokenBalance = await _contractService
        .getTokenBalance(EthereumAddress.fromHex(address));
    var ethBalance =
        await _contractService.getEthBalance(EthereumAddress.fromHex(address));

    this.tokenBalance = tokenBalance * BigInt.from(pow(10, 9));
    this.ethBalance = ethBalance.getInWei;
  }

  @action
  Future<void> resetWallet() async {
    await _configurationService.setMnemonic(null);
    await _configurationService.setupDone(false);

    this.transactions.clear();
  }

  @action
  Future<void> fetchEthGasPrice() async {
    var gasPrice = await _contractService.getEthGasPrice();

    this.ethGasPrice = gasPrice.getInWei;
  }

  @action
  Future getUserInfo(BuildContext context) async {
    final loginStore = Provider.of<LoginStore>(context);

    final user = await loginStore.getUser();
    username = user.displayName ?? user.email;
  }

  @action
  Future signOut(BuildContext context) async {
    final loginStore = Provider.of<LoginStore>(context);
    await loginStore.signOut(context);
  }

  @action
  Future deleteUser(BuildContext context) async {
    final loginStore = Provider.of<LoginStore>(context);
    final res = await loginStore.deleteUser(context);
    if (res == 'user deleted') {
      await fetchOwnBalance();

      transfer().listen((tx) {
        switch (tx.status) {
          case TransactionStatus.started:
            print('transact pending ${tx.key}');
            break;
          case TransactionStatus.confirmed:
            print('transact confirmed ${tx.key}');
            break;
          default:
            break;
        }
      }).onError((error) => print(error.message));

      await resetWallet();

      Get.offAllNamed("/");
    }
  }

  @action
  Stream<Transaction> transfer() {
    var controller = StreamController<Transaction>();
    var transactionEvent = Transaction();

    var amount = BigInt.from(this.tokenBalance / BigInt.from(pow(10, 9)));
    var network = configurationService.getNetwork();
    var contractAddress = AppConfig().params[network].contractAddress;

    _contractService.send(
        this.privateKey, EthereumAddress.fromHex(contractAddress), amount,
        onTransfer: (from, to, value) {
      controller.add(transactionEvent.confirmed(from, to, value));
      controller.close();
    }, onError: (ex) {
      controller.addError(ex);
    }).then(
        (id) => {if (id != null) controller.add(transactionEvent.setId(id))});

    return controller.stream;
  }
}
