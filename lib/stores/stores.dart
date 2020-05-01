import 'package:pblcwallet/app_config.dart';
import 'package:pblcwallet/data/fetchEtherscanData.dart';
import 'package:pblcwallet/service/address_service.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/service/contract_service.dart';
import 'package:pblcwallet/stores/login_store.dart';
import 'package:pblcwallet/stores/wallet_buy_sell_store.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:pblcwallet/utils/contract_parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../main.dart';

Future<List<SingleChildCloneableWidget>> createStore(
    AppConfigParams params) async {
  client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  //final sharedPrefs = await SharedPreferences.getInstance();

  //configurationService = ConfigurationService(sharedPrefs);
  addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'assets/PoliticoinToken.json', params.contractAddress);

  contractService = ContractService(client, contract);
  walletStore = WalletStore(
    contractService,
    addressService,
    configurationService,
  );

  walletCreateStore = WalletCreateStore(walletStore, addressService);
  walletImportStore = WalletImportStore(walletStore, addressService);
  walletTransferStore = WalletTransferStore(walletStore, contractService);
  walletBuySellStore = WalletBuySellStore(walletStore, contractService);
  walletTransactionsStore = WalletTransactionsStore(walletStore);

  // initial state.
  if (configurationService.didSetupWallet()) {
    await walletStore.initialise();
    configurationService.setNetwork(params.network);
  }

  LoginStore loginStore = LoginStore(configurationService);
  isLoggedIn = await loginStore.isLoggedIn();

  return [
    Provider<WalletStore>(create: (_) => walletStore),
    Provider<WalletTransferStore>(create: (_) => walletTransferStore),
    Provider<WalletCreateStore>(create: (_) => walletCreateStore),
    Provider<WalletImportStore>(create: (_) => walletImportStore),
    Provider<ConfigurationService>(create: (_) => configurationService),
    Provider<WalletBuySellStore>(create: (_) => walletBuySellStore),
    Provider<WalletTransactionsStore>(create: (_) => walletTransactionsStore),
    Provider<FetchEtherscanData>(create: (_) => FetchEtherscanData.create(configurationService)),
    Provider<LoginStore>(create: (_) => loginStore)
  ];
}