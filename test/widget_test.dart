// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:pblcwallet/service/address_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return private key from mnemonic', () {
    final addressService = AddressService(null);
    final privateKey = addressService.getPrivateKey(
        "loan absorb orange crouch mixed position sweet law ghost habit upgrade toss");
    expect(privateKey,
        "926675e8e39e176d86fb55ea01c577325b6e385fa147bd7ceb72c7f9949a7a96");
  });
}
