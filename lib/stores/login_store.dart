import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:pblcwallet/data/fetchFacebookData.dart';
import 'package:pblcwallet/model/facebookProfileModel.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  LoginStoreBase(this._configurationService);

  final IConfigurationService _configurationService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn;
  FacebookLogin facebookSignIn;

  @observable
  String name;
  @observable
  String email;
  @observable
  String imageUrl;

  Future<String> signInWithFacebook() async {
    facebookSignIn = FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final token = accessToken.token;
        print(token);
        /*
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         */

        /*
        final facebookData = FetchFacebookData.create();
        final graphResponse = await facebookData.getProfile(token);
        final profile = facebookProfileModelFromJson(graphResponse.bodyString);

        assert(profile.email != null);
        assert(profile.name != null);

        name = profile.name;
        email = profile.email;
        */

        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: token,
        );

        AuthResult authResult;
        try {
          authResult = await _auth.signInWithCredential(credential);
        } catch (err) {
          print(err);
          return "error";
        }
        final FirebaseUser user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        //assert(user.email != null);
        assert(user.displayName != null);
        assert(user.photoUrl != null);
        user.providerData[0].email;

        name = user.displayName;
        email = user.providerData[0].email; //user.email;
        imageUrl = user.photoUrl;

        return 'signInWithFacebook succeeded: $user';

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

    return 'error';
  }

  Future<String> signInWithGoogle() async {
    googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      var session = await isLoggedIn();
      if (session) {
        googleSignInAccount = await googleSignIn.signInSilently();
      } else {
        googleSignInAccount = await googleSignIn.signIn();
      }
      googleSignInAuthentication = await googleSignInAccount.authentication;
    } catch (err) {
      print(err);
      return 'error';
    }

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    AuthResult authResult;
    try {
      authResult = await _auth.signInWithCredential(credential);
    } catch (err) {
      print(err);
      return "error";
    }

    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;

    return 'signInWithGoogle succeeded: $user';
  }

  Future signOutGoogle(BuildContext context) async {
    await _auth.signOut();
    await googleSignIn.signOut();
    _configurationService.setLoggedIn(false);
    print("User Google Sign Out");
  }

  Future signOutFacebook(BuildContext context) async {
    await _auth.signOut();
    await facebookSignIn.logOut();
    _configurationService.setLoggedIn(false);
    print("User Facebook Sign Out");
  }

  Future attemptGoogleSignIn(BuildContext context) async {
    signInWithGoogle().then((res) {
      if (res != 'error') {
        Navigator.pushNamed(context, '/main-page');
      }
    });
  }

  Future attemptFacebookSignIn(BuildContext context) async {
    signInWithFacebook().then((res) {
      if (res != 'error') {
        Navigator.pushNamed(context, '/main-page');
      }
    });
  }

  Future signOut(BuildContext context) async {
    if (googleSignIn != null) {
      await signOutGoogle(context);
    } else if (facebookSignIn != null) {
      await signOutFacebook(context);
    }

    _configurationService.setLoggedIn(false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  Future<bool> isLoggedIn() async {
    final currentUser = await _auth.currentUser();
    _configurationService.setLoggedIn(currentUser != null);
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    final currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<String> deleteUser(BuildContext context) async {
    final currentUser = await _auth.currentUser();
    try {
      await currentUser.delete();
      return 'user deleted';
    } catch (err) {
      print(err);
      deleteDialog(context, err.message);
      return 'error';
    }
  }

  deleteDialog(BuildContext context, String err) {
    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(err),
      content: Text(""),
      actions: [
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
