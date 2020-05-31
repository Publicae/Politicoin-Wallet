// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetchEtherscanData.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$FetchEtherscanData extends FetchEtherscanData {
  _$FetchEtherscanData([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FetchEtherscanData;

  @override
  Future<Response<dynamic>> fetchData(String address) {
    final $url =
        '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX&address=$address';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postData(Map<String, dynamic> body) {
    final $url =
        '?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX&address=';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$FetchEthereumPrice extends FetchEthereumPrice {
  _$FetchEthereumPrice([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FetchEthereumPrice;

  @override
  Future<Response<dynamic>> fetchEthereumPrice() {
    final $url =
        '?module=stats&action=ethprice&apikey=8VAG1Q1FGH2EBP8RI7NF7IQR111ZI58TJX';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
