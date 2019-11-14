import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:pblcwallet/utils/contract_parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

Future<List<SingleChildCloneableWidget>> createStore(
    AppConfigParams params) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final sharedPrefs = await SharedPreferences.getInstance();

  final configurationService = ConfigurationService(sharedPrefs);
  final addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'assets/TargaryenCoin.json', params.contractAddress);

  final contractService = ContractService(client, contract);
  final walletStore = WalletStore(
    contractService,
    addressService,
    configurationService,
  );
  final walletCreateStore = WalletCreateStore(walletStore, addressService);
  final walletImportStore = WalletImportStore(walletStore, addressService);
  final walletTransferStore = WalletTransferStore(walletStore, contractService);

  // intial state.
  if (configurationService.didSetupWallet()) {
    await walletStore.initialise();
  }

  return [
    Provider<WalletStore>(builder: (_) => walletStore),
    Provider<WalletTransferStore>(builder: (_) => walletTransferStore),
    Provider<WalletCreateStore>(builder: (_) => walletCreateStore),
    Provider<WalletImportStore>(builder: (_) => walletImportStore),
    Provider<ConfigurationService>(builder: (_) => configurationService),
  ];
}
