import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_radio.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WalletImportPage extends StatefulWidget {
  WalletImportPage(
    this.store, {
    this.title,
  });

  final WalletImportStore store;
  final String title;

  @override
  State<StatefulWidget> createState() => _WalletImportPage();
}

class _WalletImportPage extends State<WalletImportPage> {
  @override
  void initState() {
    super.initState();
    widget.store.reset();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Observer(
          builder: (context) => buildForm(context),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
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
                    "Import Account",
                    style: TextStyle(fontSize: 32.0, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Import your account using a private key \n or a previous seed phrase.",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Color(0xfff6f6f6),
                    ),
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: PaperForm(
                      padding: 10,
                      actionButtons: <Widget>[
                        Expanded(child:
                        Container(
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
                                  if (widget.store.type ==
                                          WalletImportType.mnemonic &&
                                      await widget.store.confirmMnemonic()) {
                                    Navigator.of(context)
                                        .popAndPushNamed("/main-page");
                                  }
                                  if (widget.store.type ==
                                          WalletImportType.privateKey &&
                                      await widget.store.confirmPrivateKey()) {
                                    Navigator.of(context)
                                        .popAndPushNamed("/main-page");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),),
                      ],
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            PaperRadio(
                              "Seed Phrase",
                              groupValue: widget.store.type,
                              value: WalletImportType.mnemonic,
                              onChanged: (value) => widget.store.setType(value),
                            ),
                            PaperRadio(
                              "Private Key",
                              groupValue: widget.store.type,
                              value: WalletImportType.privateKey,
                              onChanged: (value) => widget.store.setType(value),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Visibility(
                                child: privateKeyForm(),
                                visible: widget.store.type ==
                                    WalletImportType.privateKey),
                            Visibility(
                                child: mnemonicForm(),
                                visible: widget.store.type ==
                                    WalletImportType.mnemonic),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privateKeyForm() {
    return Column(
      children: <Widget>[
        PaperInput(
          labelText: 'Private Key',
          hintText: 'Type your private key',
          maxLines: 3,
          onChanged: widget.store.setPrivateKey,
          filled: true,
          fillColor: Colors.white,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff515151),
          ),
        ),
        SizedBox(height: 10),
        PaperValidationSummary(widget.store.errors),
      ],
    );
  }

  Widget mnemonicForm() {
    return Column(
      children: <Widget>[
        PaperInput(
          labelText: 'Seed Phrase',
          hintText: 'Type your seed phrase',
          maxLines: 3,
          onChanged: widget.store.setMnemonic,
          filled: true,
          fillColor: Colors.white,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff515151),
          ),
        ),
        SizedBox(height: 10),
        Observer(
          builder: (context) => PaperValidationSummary(widget.store.errors),
        ),
      ],
    );
  }
}
