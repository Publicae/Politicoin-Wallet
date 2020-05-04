// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetchFacebookData.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$FetchFacebookData extends FetchFacebookData {
  _$FetchFacebookData([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FetchFacebookData;

  @override
  Future<Response<dynamic>> getProfile(String token) {
    final $url = '?fields=name,first_name,last_name,email&access_token=$token';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
