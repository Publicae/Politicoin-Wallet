import 'package:chopper/chopper.dart';
import 'package:pblcwallet/service/configuration_service.dart';

part 'fetchEtherscanData.chopper.dart';

// IMPORTANT!!!!
// after buildingchange in fetchEtherscanData.chopper.dart make sure it is like below 
// final $url = '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=$apiKey&address=$address';

@ChopperApi(baseUrl: '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=')
abstract class FetchEtherscanData extends ChopperService {
  @Get(path: '{apiKey}&address={address}')
  Future<Response> fetchData(@Path('address') String address, @Path('apiKey') String apiKey);
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

@ChopperApi(baseUrl: '?module=stats&action=ethprice&apikey=')
abstract class FetchEthereumPrice extends ChopperService {
  @Get(path: '{apiKey}')
  Future<Response> fetchEthereumPrice(@Path('apiKey') String apiKey);
  
  static FetchEthereumPrice create(ConfigurationService configurationService) {
  
    //etherscan API
    var etherscanNetwork = "api";
    if (configurationService.getNetwork() != "mainnet") {
      etherscanNetwork = "api-${configurationService.getNetwork()}";
    }

    final client = ChopperClient(
      baseUrl: 'https://$etherscanNetwork.etherscan.io/api',
      services: [_$FetchEthereumPrice()],
      converter: JsonConverter(),
    );
    return _$FetchEthereumPrice(client);
  }
}