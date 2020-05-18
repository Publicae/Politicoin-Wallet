import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pblcwallet/components/buttons/copy_button.dart';
import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WalletCreatePage extends StatefulWidget {
  WalletCreatePage(
    this.store, {
    this.title,
  });

  final WalletCreateStore store;
  final String title;

  @override
  State<StatefulWidget> createState() => _WalletCreatePage();
}

class _WalletCreatePage extends State<WalletCreatePage> {
  @override
  void initState() {
    super.initState();
    widget.store.generateMnemonic();
  }

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
          onPressed: () => Get.toNamed("/"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Builder(
          builder: (context) => buildForm(context),
          // return widget.store.step == WalletCreateSteps.display
          //     ? _displayMnemonic()
          //     : _confirmMnemonic();
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bkg1.png"),
                fit: BoxFit.fill,
              ),
            ),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Mnemonic Setup",
                  style: TextStyle(fontSize: 32.0, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Generate a new mnemonic or \n import your account",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Color(0xfff6f6f6),
                    ),
                    height: 235,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Text(
                            "12-word bip39 mnemonic",
                            style: TextStyle(
                                fontSize: 18.0, color: Color(0xff696969)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Observer(
                              builder: (_) => Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Text(
                                    widget.store.mnemonic,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xff858585)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(Icons.content_copy),
                                tooltip: 'copy address',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: widget.store.mnemonic),
                                  );
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Copied"),
                                    ),
                                  );
                                },
                                color: Color(0xff858585),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffe1e1e1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: FlatButton(
                                    child: const Text(
                                      'Generate New',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff818181),
                                      ),
                                    ),
                                    onPressed: () async {
                                      widget.store.generateMnemonic();
                                    }),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/bkg5.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: FlatButton(
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      showAlert("Save your seed phrase", "Make sure you write down your 12-word mnemonic, or take a screenshot!", () async {
                                        if (await widget.store
                                            .confirmMnemonic()) {
                                          Get.offNamed("/main-page");
                                        }
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          title: Text(
                            'Keep your seed phrase somewhere safe and do not lose it! Otherwise you will not be able to retrieve your accounts!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          leading: Icon(Icons.info),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Color(0xfff6f6f6),
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Text(
                            "import an account",
                            style: TextStyle(
                                fontSize: 18.0, color: Color(0xff696969)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage("assets/images/bkg5.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  child: const Text(
                                    'Import Account',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Get.toNamed("/import");
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlert(String title, String message, Function onPressed) {
    Get.defaultDialog(
      title: title,
      content: Text(message),
      confirm: FlatButton(
        child: Text("Yes, proceed"),
        onPressed: onPressed,
      ),
      cancel: FlatButton(
        child: Text("Cancel"),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _displayMnemonic() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Get a piece of papper, write down your seed phrase and keep it safe. This is the only way to recover your funds.",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.all(25),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: Observer(
                  builder: (_) => Text(
                    widget.store.mnemonic,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CopyButton(
                    text: const Text('Copy'),
                    value: widget.store.mnemonic,
                  ),
                  RaisedButton(
                    child: const Text('Next'),
                    onPressed: () {
                      widget.store.goto(WalletCreateSteps.confirm);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmMnemonic() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              OutlineButton(
                child: const Text('Generate New'),
                onPressed: () async {
                  widget.store.generateMnemonic();
                },
              ),
              RaisedButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  if (await widget.store.confirmMnemonic()) {
                    Get.offNamed("/main-page");
                  }
                },
              )
            ],
            children: <Widget>[
              PaperValidationSummary(widget.store.errors),
              PaperInput(
                labelText: 'Confirm your seed',
                hintText: 'Please type your seed phrase again',
                maxLines: 2,
                onChanged: widget.store.setMnemonicConfirmation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
