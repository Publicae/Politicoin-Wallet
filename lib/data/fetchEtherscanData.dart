import 'package:chopper/chopper.dart';
import 'package:pblcwallet/service/configuration_service.dart';

part 'fetchEtherscanData.chopper.dart';

// IMPORTANT!!!!
// after buildingchange in fetchEtherscanData.chopper.dart
// final $url = '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX&address=$address';

@ChopperApi(baseUrl: '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX&address=')
abstract class FetchEtherscanData extends ChopperService {
  @Get(path: '{address}')
  Future<Response> fetchData(@Path('address') String address);
  @Post()
  Future<Response> postData(@Body() Map<String, dynamic> body);

  static FetchEtherscanData create(ConfigurationService configurationService) {
  
    //etherscan API
    var etherscanNetwork = "api";
    if (configurationService.getNetwork() != "mainnet") {
      etherscanNetwork = "api-${configurationService.getNetwork()}";
    }

    final client = ChopperClient(
      baseUrl: 'https://$etherscanNetwork.etherscan.io/api',
      services: [_$FetchEtherscanData()],
      converter: JsonConverter(),
    );
    return _$FetchEtherscanData(client);
  }
}