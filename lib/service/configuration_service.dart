import 'package:shared_preferences/shared_preferences.dart';

abstract class IConfigurationService {
  Future<void> setMnemonic(String value);
  Future<void> setupDone(bool value);
  Future<void> setPrivateKey(String value);
  Future<void> setNetwork(String value);
  Future<void> setLoggedIn(bool value);
  String getMnemonic();
  String getPrivateKey();
  bool didSetupWallet();
  String getNetwork();
  bool getLoggedIn();
}

class ConfigurationService implements IConfigurationService {
  SharedPreferences _preferences;
  ConfigurationService(this._preferences);

  @override
  Future<void> setMnemonic(String value) async {
    await _preferences.setString("mnemonic", value);
  }

  @override
  Future<void> setPrivateKey(String value) async {
    await _preferences.setString("privateKey", value);
  }

  @override
  Future<void> setupDone(bool value) async {
    await _preferences.setBool("didSetupWallet", value);
  }

  @override
  Future<void> setNetwork(String value) async {
    await _preferences.setString("network", value);
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _preferences.setBool("loggedIn", value);
  }

  // gets
  @override
  String getMnemonic() {
    return _preferences.getString("mnemonic");
  }

  @override
  String getPrivateKey() {
    return _preferences.getString("privateKey");
  }

  @override
  bool didSetupWallet() {
    return _preferences.getBool("didSetupWallet") ?? false;
  }

  @override
  String getNetwork() {
    return _preferences.getString("network") ?? "mainnet";
  }

  @override
  bool getLoggedIn() {
    return _preferences.getBool("loggedIn");
  }
}
