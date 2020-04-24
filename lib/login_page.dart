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
            ],
          ),
        ),
      ),
    );
  }
}
