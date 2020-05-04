import 'package:get/get.dart';
import 'package:pblcwallet/components/transactions/transaction_list.dart';
import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletTransactionsPage extends StatefulWidget {
  WalletTransactionsPage(this.store, {Key key, this.title}) : super(key: key);

  final WalletTransactionsStore store;
  final String title;

  @override
  _WalletTransactionsPageState createState() => _WalletTransactionsPageState();
}

class _WalletTransactionsPageState extends State<WalletTransactionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final String hash = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/back.png"),
          ),
          onPressed: () => Get.back(),
        ),
        actions: <Widget>[
          IconButton(
            icon: ImageIcon(
              AssetImage("assets/images/etherscan.png"),
            ),
            onPressed: () async {
              final network = configurationService.getNetwork();
              final pk = configurationService.getPrivateKey();
              final address = await addressService.getPublicAddress(pk);
              var url = 'https://$network.etherscan.io/address/$address';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) => buildForm(ctx),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bkg1.png"),
                fit: BoxFit.fill,
              ),
            ),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Powered by Etherscan.io APIs",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TransactionList(widget.store),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("INFO: cancelling timer");
    widget.store.timer.cancel();
    widget.store.timer = null;
  }
}
