import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/router.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/stores.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:pblcwallet/stores/wallet_buy_sell_store.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

List<SingleChildCloneableWidget> stores;
Web3Client client;
WalletStore walletStore;
ConfigurationService configurationService;
AddressService addressService;
ContractService contractService;
WalletBuySellStore walletBuySellStore;
WalletCreateStore walletCreateStore;
WalletImportStore walletImportStore;
WalletTransferStore walletTransferStore;
WalletTransactionsStore walletTransactionsStore;
bool isLoggedIn;

void main() async {
  // bootstrapping;
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  configurationService = ConfigurationService(sharedPrefs);
  var network = configurationService.getNetwork();
  stores = await createStore(AppConfig().params[network]);

  runApp(Phoenix(
    child: MainApp(stores),
  ));
}

class MainApp extends StatelessWidget {
  MainApp(this.stores);
  final List<SingleChildCloneableWidget> stores;
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: stores,
      child: new MaterialApp(
        title: 'PBLC',
        initialRoute: isLoggedIn ? '/main-page' : '/',
        routes: getRoutes(context),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
      ),
    );
  }
}
