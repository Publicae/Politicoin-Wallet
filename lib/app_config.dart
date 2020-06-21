import 'package:pblcwallet/api_keys.dart';

class AppConfig {
  AppConfig() {
    params['dev'] = AppConfigParams(
        "http://192.168.182.2:7546",
        "ws://192.168.182.2:7546",
        "0x59FFB6Ea7bb59DAa2aC480D862d375F49F73915d",
        "development");

    params['ropsten'] = AppConfigParams(
        "https://ropsten.infura.io/v3/${ApiKeys.infuraApiKey}",
        "wss://ropsten.infura.io/ws/v3/${ApiKeys.infuraApiKey}",
        "0x7cbec5bcb81fd24db92f401f97c1dd48338f8df8",
        "ropsten");

    params['kovan'] = AppConfigParams(
        "https://kovan.infura.io/v3/${ApiKeys.infuraApiKey}",
        "wss://kovan.infura.io/ws/v3/${ApiKeys.infuraApiKey}",
        "not_yet_deployed",
        "kovan");

    params['rinkeby'] = AppConfigParams(
        "https://rinkeby.infura.io/v3/${ApiKeys.infuraApiKey}",
        "wss://kovan.infura.io/ws/v3/${ApiKeys.infuraApiKey}",
        "0x7d9abcb2633e17debbafd400ce15003057219cd2",
        "rinkeby");

    params['goerli'] = AppConfigParams(
        "https://goerli.infura.io/v3/${ApiKeys.infuraApiKey}",
        "wss://goerli.infura.io/ws/v3/${ApiKeys.infuraApiKey}",
        "not_yet_deployed",
        "goerli");

    params['mainnet'] = AppConfigParams(
        "https://mainnet.infura.io/v3/${ApiKeys.infuraApiKey}",
        "wss://mainnet.infura.io/ws/v3/${ApiKeys.infuraApiKey}",
        "0x6ffbd6b41b802550c57d4661d81a1700a502f2ab",
        "mainnet");
  }

  Map<String, AppConfigParams> params = Map<String, AppConfigParams>();

  // https://etherscan.io/gastracker
  static final gasPrice = 5000000000; // 5gwei
  static final maxGas = 3000000;

  static final pp = "http://publicae.org/privacy-policy/";
  static final tos = "https://publicae.org/terms-of-service/";
}

class AppConfigParams {
  AppConfigParams(this.web3HttpUrl, this.web3RdpUrl, this.contractAddress, this.network);
  final String web3RdpUrl;
  final String web3HttpUrl;
  final String contractAddress;
  final String network;
}
