import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:pblcwallet/service/configuration_service.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  LoginStoreBase(this._configurationService);

  final IConfigurationService _configurationService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @observable
  String name;
  @observable
  String email;
  @observable
  String imageUrl;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
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
    await googleSignIn.signOut();
    print("User Google Sign Out");
  }

  Future attemptGoogleSignIn(BuildContext context) async {
    signInWithGoogle().whenComplete(() {
      Navigator.pushNamed(context, '/main-page');
    });
  }

  Future signOut(BuildContext context) async {
    if (googleSignIn != null) {
      await signOutGoogle(context);
    }

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
}
