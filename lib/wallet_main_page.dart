import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pblcwallet/components/buttons/network_dropdown_button.dart';
import 'package:pblcwallet/components/wallet/balance.dart';
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

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ListTile(
            //   title: Text("Get tokens "),
            //   subtitle: Text("Receive some test tokens"),
            //   trailing: Icon(Icons.attach_money),
            //   onTap: () async {
            //     var url =
            //         'http://ec2-54-213-50-23.us-west-2.compute.amazonaws.com/transfer?address=${widget.walletStore.address}';
            //     if (await canLaunch(url)) {
            //       await launch(url);
            //     } else {
            //       throw 'Could not launch $url';
            //     }
            //   },
            // ),
            Observer(
                builder: (_) => ListTile(
                      title: Text(
                        "PBLC Wallet",
                        style: TextStyle(fontSize: 32.0),
                      ),
                      subtitle: Text(widget.walletStore.username),
                    )),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              title: Text("Reset wallet"),
              subtitle: Text(
                  "warning: without your seed phrase you cannot restore your wallet"),
              trailing: Icon(Icons.warning),
              onTap: () {
                showAlertDialog(context);
              },
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              title: Text("Send"),
              subtitle: Text("PBLC or ETH"),
              onTap: () async {
                Navigator.popAndPushNamed(context, "/transfer");
              },
            ),
            ListTile(
              title: Text("Buy / Sell "),
              subtitle: Text("Buy or Sell PBLC tokens"),
              onTap: () async {
                Navigator.popAndPushNamed(context, "/buy-sell");
              },
            ),
            ListTile(
              title: Text("My Transactions"),
              subtitle: Text("see sent and received transactions"),
              onTap: () async {
                Navigator.popAndPushNamed(context, "/transactions");
              },
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              title: Text("Change Network"),
              subtitle: Text("warning: this will restart the app!"),
            ),
            NetworkDropdown(widget.currentNetwork),
            ListTile(
              title: Text("Sign Out"),
              subtitle: Text(""),
              onTap: () {
                signOutDialog(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await widget.walletStore.fetchOwnBalance();
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              Navigator.of(context).pushNamed("/transfer");
            },
          ),
        ],
      ),
      body: Consumer<WalletStore>(
        builder: (context, walletStore, _) => Balance(walletStore),
      ),
    );
  }

  refreshBalance() async {
    await widget.walletStore.fetchOwnBalance();
  }

  getUserInfo() async {
    await widget.walletStore.getUserInfo(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Reset"),
      onPressed: () async {
        await widget.walletStore.resetWallet();
        // Navigator.popAndPushNamed(context, "/main-page");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset wallet?"),
      content: Text(
          "warning: without your seed phrase you cannot restore your wallet"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signOutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Sign Out"),
      onPressed: () async {
        await widget.walletStore.signOut(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign Out?"),
      content: Text(""),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
