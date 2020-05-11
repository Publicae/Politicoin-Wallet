import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/stores/login_store.dart';
import 'package:url_launcher/url_launcher.dart';

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
    widget.loginStore.isAppleSignInSupported();
    _accountController.value =
        TextEditingValue(text: widget.loginStore.accountId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Observer(
        builder: (_) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: widget.loginStore.loading != null &&
                      widget.loginStore.loading
                  ? Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitWanderingCubes(
                              color: Color(0xff818181),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // FlutterLogo(size: 150),
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
                                    "Sign In Now",
                                    style: TextStyle(
                                        fontSize: 32.0, color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Please sign in below \n to use the Politicoin app wallet",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(20),
                                children: <Widget>[
                                  if (widget.loginStore.supportsAppleSignIn)
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: SignInButton(
                                        Buttons.AppleDark,
                                        text: "Continue with Apple",
                                        onPressed: () async {
                                          await widget.loginStore
                                              .attemptAppleSignIn(context);
                                        },
                                      ),
                                    ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, right: 40.0),
                                    child: SignInButton(
                                      Buttons.Google,
                                      text: "Sign in with Google",
                                      onPressed: () async {
                                        await widget.loginStore
                                            .attemptGoogleSignIn(context);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, right: 40.0),
                                    child: SignInButton(
                                      Buttons.Facebook,
                                      text: "Sign in with Facebook",
                                      onPressed: () async {
                                        await widget.loginStore
                                            .attemptFacebookSignIn(context);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, right: 40.0),
                                    child: Text(
                                      "Make sure you have a different email account, in Google and Facebook!",
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Text(
                                    "or enter your account id",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, right: 40.0),
                                    child: TextField(
                                      controller: _accountController,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xfff3f3f3),
                                        labelText: 'account id',
                                        labelStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 15.0, top: 5.0, bottom: 5.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey,
                                      ),
                                      onChanged: widget.loginStore.setAccountId,
                                      onSubmitted: (String value) async {
                                        // apple review account
                                        if (value ==
                                            'ZIE5Wkj1t3V0x5ZAMS3W4UI5mKz2') {
                                          await widget.loginStore
                                              .attemptEmailSignIn(
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
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text(
                                          "Terms of Service",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () async {
                                          var url = AppConfig.tos;
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      ),
                                      Text(
                                        " | ",
                                        style: TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "Privacy Policy",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () async {
                                          var url = AppConfig.pp;
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }
}
