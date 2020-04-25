import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pblcwallet/stores/login_store.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.loginStore, {Key key, this.title}) : super(key: key);

  final LoginStore loginStore;
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.loginStore.reset();
    _accountController.value =
        TextEditingValue(text: widget.loginStore.accountId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // FlutterLogo(size: 150),
              Image.asset(
                'assets/icon/iTunesArtwork@3x.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 50),
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () async {
                  await widget.loginStore.attemptGoogleSignIn(context);
                },
              ),
              SignInButton(
                Buttons.Facebook,
                text: "Sign in with Facebook",
                onPressed: () async {
                  await widget.loginStore.attemptFacebookSignIn(context);
                },
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Make sure you use a different email account, in Google and Facebook, otherwise only one of them can be used!"),
              ),
              Divider(),
              Text("or enter the account id you have from Publicae"),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _accountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type your account id',
                  ),
                  onChanged: widget.loginStore.setAccountId,
                  onSubmitted: (String value) async {
                    // apple review account
                    if (value == 'ZIE5Wkj1t3V0x5ZAMS3W4UI5mKz2') {
                      await widget.loginStore.attemptEmailSignIn(
                        context,
                        "apple-review@publicae.com",
                        "123456789",
                      );
                    } else {
                      // future functionality
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }
}
