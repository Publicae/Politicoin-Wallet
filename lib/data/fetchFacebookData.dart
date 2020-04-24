import 'package:chopper/chopper.dart';

part 'fetchFacebookData.chopper.dart';

@ChopperApi(baseUrl: '?fields=name,first_name,last_name,email&access_token=')
abstract class FetchFacebookData extends ChopperService {
  @Get(path: '{access_token}')
  Future<Response> getProfile(@Path('access_token') String token);

  static FetchFacebookData create() {
    final client = ChopperClient(
      baseUrl: 'https://graph.facebook.com/v2.12/me',
      services: [_$FetchFacebookData()],
      converter: JsonConverter(),
    );
    return _$FetchFacebookData(client);
  }
}