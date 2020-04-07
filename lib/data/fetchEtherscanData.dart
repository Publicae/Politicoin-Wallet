import 'package:chopper/chopper.dart';

part 'fetchEtherscanData.chopper.dart';

@ChopperApi(baseUrl: '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX&address=')
abstract class FetchEtherscanData extends ChopperService {
  @Get(path: '{address}')
  Future<Response> fetchData(@Path('address') String address);
  @Post()
  Future<Response> postData(@Body() Map<String, dynamic> body);

  static FetchEtherscanData create() {
    final client = ChopperClient(
      baseUrl: 'https://api-ropsten.etherscan.io/api',
      services: [_$FetchEtherscanData()],
      converter: JsonConverter(),
    );
    return _$FetchEtherscanData(client);
  }
}