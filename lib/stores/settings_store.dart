import 'package:mobx/mobx.dart';
import 'package:package_info/package_info.dart';
import 'package:pblcwallet/service/configuration_service.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  SettingsStoreBase(this._configurationService);

  final IConfigurationService _configurationService;

  @observable
  String version = "";

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    this.version = "v$version ($buildNumber)";
  }
}
