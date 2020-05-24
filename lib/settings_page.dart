import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/components/buttons/network_dropdown_button.dart';
import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/stores/settings_store.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this.store, {Key key, this.title, this.currentNetwork})
      : super(key: key);

  final SettingsStore store;
  final String title;
  final String currentNetwork;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    widget.store.getVersion();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Builder(
          builder: (ctx) => buildForm(ctx),
        ),
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
                    configurationService.getNetwork(),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontFamily: 'Courier New',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: false,
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                    color: Color(0xfff3f3f3),
                  ),
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Text(
                          "Ethereum Network Setting",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xff3f3f3f),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Changing this will restart the wallet!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        leading: Icon(Icons.info),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: NetworkDropdown(widget.currentNetwork),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(20.0),
                //       topLeft: Radius.circular(20.0),
                //     ),
                //     color: Color(0xfff3f3f3),
                //   ),
                //   height: 70,
                //   width: MediaQuery.of(context).size.width,
                //   child: ListTile(
                //     title: Text(
                //       'Gas Price Setting',
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Color(0xff3f3f3f),
                //       ),
                //     ),
                //     subtitle: Text(
                //       "${AppConfig.gasPrice.toString()} (5gwei)",
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                    color: Color(0xfff3f3f3),
                  ),
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Observer(
                    builder: (_) => ListTile(
                      title: Text(
                        'Version',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff3f3f3f),
                        ),
                      ),
                      subtitle: Text(
                        widget.store.version,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
