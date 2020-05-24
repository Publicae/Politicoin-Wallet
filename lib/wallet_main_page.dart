import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:pblcwallet/components/wallet/balance.dart';
import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletMainPage extends StatefulWidget {
  WalletMainPage(this.walletStore, {Key key, this.title, this.currentNetwork})
      : super(key: key);

  final WalletStore walletStore;
  final String title;
  final String currentNetwork;

  @override
  _WalletMainPageState createState() => _WalletMainPageState();
}

class _WalletMainPageState extends State<WalletMainPage> {
  @override
  Widget build(BuildContext context) {
    refreshBalance();
    getUserInfo();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _createHeader(),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0, 15),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
                              child: Text(
                                configurationService.getNetwork(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff696969),
                                  fontFamily: 'Courier New',
                                ),
                              )),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0, 15),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            child: FlatButton(
                              onPressed: () => Get.toNamed('\settings'),
                              padding: EdgeInsets.all(0.0),
                              child:
                                  Image.asset('assets/images/settings_r.png'),
                            ),
                          ),
                          Container(
                            width: 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0, 15),
                                  height: 1,
                                  color: Color(0xaa858585),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1e616161),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ListTile(
                            title: Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff696969),
                              ),
                            ),
                            //subtitle: Text("see sent and received transactions"),
                            leading: ImageIcon(
                                AssetImage("assets/images/transactions.png")),
                            trailing: Icon(
                              Icons.arrow_right,
                              color: Color(0xff696969),
                            ),
                            onTap: () async {
                              Get.toNamed("/transactions");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1e616161),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ListTile(
                            title: Text(
                              "Send",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff696969),
                              ),
                            ),
                            //subtitle: Text("PBLC or ETH"),
                            leading:
                                ImageIcon(AssetImage("assets/images/send.png")),
                            trailing: Icon(
                              Icons.arrow_right,
                              color: Color(0xff696969),
                            ),
                            onTap: () async {
                              Get.toNamed("/transfer");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1e616161),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ListTile(
                            title: Text(
                              "Buy / Sell PBLC",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff696969),
                              ),
                            ),
                            //subtitle: Text("Buy or Sell PBLC tokens"),
                            leading: ImageIcon(
                                AssetImage("assets/images/receive.png")),
                            trailing: Icon(
                              Icons.arrow_right,
                              color: Color(0xff696969),
                            ),
                            onTap: () async {
                              Get.toNamed("/buy-sell");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 150, 0),
                        height: 1,
                        color: const Color(0xaa858585),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 1, 150, 0),
                        height: 1,
                        color: const Color(0xaa858585),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1e616161),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ListTile(
                            title: Text(
                              "Reset Wallet",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff696969),
                              ),
                            ),
                            leading: ImageIcon(
                                AssetImage("assets/images/wallet.png")),
                            trailing: Icon(
                              Icons.warning,
                              color: Color(0xff696969),
                            ),
                            onTap: () {
                              showAlert(
                                "Reset wallet?",
                                "Without your seed phrase or private key, you cannot restore your wallet!",
                                () async {
                                  await widget.walletStore.resetWallet();
                                  Get.offAllNamed("/create");
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1e616161),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ListTile(
                            title: Text(
                              "Delete Account",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff696969),
                              ),
                            ),
                            leading: ImageIcon(
                                AssetImage("assets/images/profile.png")),
                            trailing: Icon(
                              Icons.warning,
                              color: Color(0xff696969),
                            ),
                            onTap: () {
                              showAlert(
                                "Delete Account?",
                                "This cannot be reversed! You will lose all your PBLC tokens!",
                                () async {
                                  await widget.walletStore.deleteUser(context);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        child: Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage("assets/images/bkg5.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ), // button text
                        ),
                        onTap: () {
                          showAlert("Sign Out?", "", () async {
                            await widget.walletStore.signOut(context);
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      Observer(
                        builder: (_) => Text(
                          widget.walletStore.version,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff696969),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: ImageIcon(AssetImage("assets/images/menu.png")),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),

          // flexibleSpace: Image(
          //   image: AssetImage('assets/images/bkg1.png'),
          //   fit: BoxFit.cover,
          // ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await widget.walletStore.fetchOwnBalance();
              },
            ),
            IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/paper-plane.png"),
              ),
              onPressed: () {
                Get.toNamed("/transfer", arguments: "");
              },
            ),
          ],
        ),
        body: Consumer<WalletStore>(
          builder: (context, walletStore, _) => Balance(walletStore),
        ),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/bkg1.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            left: 40.0,
            child: Text(
              "PBLC Wallet",
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            top: 70.0,
            left: 40.0,
            child: Observer(
              builder: (_) => Text(
                widget.walletStore.username,
                style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  refreshBalance() async {
    await widget.walletStore.fetchOwnBalance();
  }

  getUserInfo() async {
    await widget.walletStore.getUserInfo(context);
  }

  showAlert(String title, String message, Function onPressed) {
    Get.defaultDialog(
        title: title,
        content: Text(message),
        confirm: FlatButton(
          child: Text("Ok"),
          onPressed: onPressed,
        ),
        cancel: FlatButton(
          child: Text("Cancel"),
          onPressed: () => Get.back(),
        ));
  }
}
