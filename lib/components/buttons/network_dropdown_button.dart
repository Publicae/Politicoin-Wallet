import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:pblcwallet/stores/stores.dart';

import '../../app_config.dart';
import '../../main.dart';

class NetworkDropdown extends StatefulWidget {
  NetworkDropdown(this.currentNetwork);
  final String currentNetwork;

  @override
  _NetworkDropdownState createState() {
    return _NetworkDropdownState();
  }
}

class _NetworkDropdownState extends State<NetworkDropdown> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Text("Current Network: "),
        DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('Mainnet'),
            value: 'mainnet',
          ),
          DropdownMenuItem<String>(
            child: Text('Ropsten'),
            value: 'ropsten',
          ),
          // DropdownMenuItem<String>(
          //   child: Text('Rinkeby'),
          //   value: 'rinkeby',
          // ),
          // DropdownMenuItem<String>(
          //   child: Text('Kovan'),
          //   value: 'kovan',
          // ),
          // DropdownMenuItem<String>(
          //   child: Text('Goerli'),
          //   value: 'goerli',
          // ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
          changeNetwork(context);
        },
        hint: Text(toBeginningOfSentenceCase(widget.currentNetwork)),
        value: _value,
      ),
      ],
    );
  }

  changeNetwork(BuildContext context) async {
    stores = [];
    stores = await createStore(AppConfig().params[_value]);
    Phoenix.rebirth(context);
  }
}
