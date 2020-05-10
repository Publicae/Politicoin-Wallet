import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
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

  @observable
  String accountId;

  @observable
  bool loading;

  @observable
  bool supportsAppleSignIn = false;

  @action
  void setAccountId(String value) {
    this.accountId = value;
  }

  @action
  void reset() {
    this.accountId = "";
  }

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
          showAlert(err.message);
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

    loading = false;
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
    } catch (err) {
      print(err);
      showAlert(err.code);
      return 'error';
    }

    if (googleSignInAccount != null) {
      googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      AuthResult authResult;
      try {
        authResult = await _auth.signInWithCredential(credential);
      } catch (err) {
        print(err);
        showAlert(err.message);
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
    } else {
      await _auth.signOut();
    }

    loading = false;
    return 'error';
  }

  Future<String> signInWithApple() async {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider =
                new OAuthProvider(providerId: "apple.com");
            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final AuthResult _res =
                await FirebaseAuth.instance.signInWithCredential(credential);

            FirebaseAuth.instance.currentUser().then((val) async {
              UserUpdateInfo updateUser = UserUpdateInfo();
              updateUser.displayName =
                  "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
              updateUser.photoUrl = "define an url";
              await val.updateProfile(updateUser);

              final FirebaseUser user = _res.user;

              assert(!user.isAnonymous);
              assert(await user.getIdToken() != null);

              final FirebaseUser currentUser = await _auth.currentUser();
              assert(user.uid == currentUser.uid);

              name = user.displayName;
              email = user.email;

              return 'signInWithApple succeeded: $updateUser';
            });
          } catch (e) {
            print("error");
            showAlert(e.message);
            loading = false;
            return "error";
          }
          break;
        case AuthorizationStatus.error:
          // do something
          loading = false;
          return "error";
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          loading = false;
          return "error";
          break;
      }
    } catch (error) {
      print("error with apple sign in");
      showAlert(error.message);
      loading = false;
      return "error";
    }
  }

  Future<String> signInWithEmail(String email, String password) async {
    AuthResult authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      print(err);
      showAlert(err.message);
      return "error";
    }

    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    assert(user.email != null);

    email = user.email;

    return 'signInWithEmail succeeded: $user';
  }

  Future signOutGoogle(BuildContext context) async {
    await googleSignIn.signOut();
    _configurationService.setLoggedIn(false);
    print("User Google Sign Out");
  }

  Future signOutFacebook(BuildContext context) async {
    await facebookSignIn.logOut();
    _configurationService.setLoggedIn(false);
    print("User Facebook Sign Out");
  }

  Future signOutApple(BuildContext context) async {
    _configurationService.setLoggedIn(false);
    print("User Apple Sign Out");
  }

  Future attemptGoogleSignIn(BuildContext context) async {
    loading = true;
    signInWithGoogle().then((res) {
      if (res != 'error') {
        loading = false;
        final route =
            _configurationService.didSetupWallet() ? '/main-page' : '/create';
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  Future attemptFacebookSignIn(BuildContext context) async {
    loading = true;
    signInWithFacebook().then((res) {
      if (res != 'error') {
        loading = false;
        final route =
            _configurationService.didSetupWallet() ? '/main-page' : '/create';
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  Future attemptAppleSignIn(BuildContext context) async {
    loading = true;
    signInWithApple().then((res) {
      if (res != 'error') {
        loading = false;
        final route =
            _configurationService.didSetupWallet() ? '/main-page' : '/create';
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  Future attemptEmailSignIn(
      BuildContext context, String email, String password) async {
    signInWithEmail(email, password).then((res) {
      if (res != 'error') {
        final route =
            _configurationService.didSetupWallet() ? '/main-page' : '/create';
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  Future signOut(BuildContext context) async {
    await _auth.signOut();
    if (googleSignIn != null) {
      await signOutGoogle(context);
    } else if (facebookSignIn != null) {
      await signOutFacebook(context);
    } else {
      await signOutApple(context);
    }

    _configurationService.setLoggedIn(false);
    Get.offAllNamed("/");
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
      showAlert(err.message);
      return 'error';
    }
  }

  showAlert(String msg) {
    Get.defaultDialog(
      title: "Error",
      content: Text(msg),
      confirm: FlatButton(
        child: Text("Ok"),
        onPressed: () => Get.back(),
      ),
    );
  }

  isAppleSignInSupported() async {
    supportsAppleSignIn = await AppleSignIn.isAvailable();
    // if (Platform.isIOS) {
    //   var iosInfo = await DeviceInfoPlugin().iosInfo;
    //   var version = iosInfo.systemVersion;

    //   if (version.contains('13') == true) {
    //     supportsAppleSignIn = true;
    //   }
    // }
  }
}
