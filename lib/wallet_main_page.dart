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
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
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
              _createHeader(),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                      height: 1,
                      color: const Color(0xaa858585),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                      height: 1,
                      color: const Color(0xaa858585),
                    ),
                    SizedBox(height: 30),
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
                            Navigator.popAndPushNamed(context, "/transactions");
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
                            Navigator.popAndPushNamed(context, "/transfer");
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
                            Navigator.popAndPushNamed(context, "/buy-sell");
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
                    ListTile(
                      title: Center(
                        child: Text(
                          "Change Network",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff515151),
                          ),
                        ),
                      ),
                      subtitle: Center(
                        child: Text("this will restart the app!"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x1e616161),
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: NetworkDropdown(widget.currentNetwork),
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
                          leading:
                              ImageIcon(AssetImage("assets/images/wallet.png")),
                          trailing: Icon(
                            Icons.warning,
                            color: Color(0xff696969),
                          ),
                          onTap: () {
                            showAlertDialog(context);
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
                            deleteDialog(context);
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
                        signOutDialog(context);
                      },
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
              Navigator.pushNamed(
                context,
                '/transfer',
                arguments: "",
              );
            },
          ),
        ],
      ),
      body: Consumer<WalletStore>(
        builder: (context, walletStore, _) => Balance(walletStore),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bkg4.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 17.0,
            right: 50.0,
            child: Text(
              "PBLC Wallet",
              style: TextStyle(
                  color: Color(0xff555555),
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 1.0,
            right: 50.0,
            child: Observer(
              builder: (_) => Text(
                widget.walletStore.username,
                style: TextStyle(
                    color: Color(0xff555555),
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
        Navigator.popAndPushNamed(context, "/create");
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

  deleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed: () async {
        await widget.walletStore.deleteUser(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account?"),
      content:
          Text("This cannot be reversed! You will lose all your PBLC tokens!"),
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
