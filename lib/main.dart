import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/router.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/stores.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:web3dart/web3dart.dart';

List<SingleChildCloneableWidget> stores;
Web3Client client;
WalletStore walletStore;
ConfigurationService configurationService;
AddressService addressService;
ContractService contractService;

void main() async {
  // bootstrapping;
  WidgetsFlutterBinding.ensureInitialized();
  stores = await createStore(AppConfig().params["ropsten"]);

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
          initialRoute: '/',
          routes: getRoutes(context),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
        ));
  }
}