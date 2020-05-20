import 'package:bip39/bip39.dart' as bip39;
import 'package:pblcwallet/utils/hd_key.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:hex/hex.dart";

void main() {
  group("Test seed", () {
    test("should have valid key", () {
      String seed = bip39.mnemonicToSeedHex("thought empty modify achieve arch tooth sign unhappy life tape team dust");
      var master = HDKey.getMasterKeyFromSeed(seed);
      expect(
          HEX.encode(master.key),
          equals(
              "1352d9efc5c511f89ff262f913e58a2d42649d47246752790cbce6987e100bfe"));
    });

    test("should have valid key", () {
      String seed = bip39.mnemonicToSeedHex("enjoy cargo census face cabin rug defense lecture shiver cram pool vehicle");
      print('seed: ' + seed);
      var master = HDKey.getMasterKeyFromSeed(seed);
      expect(
          HEX.encode(master.key),
          equals(
              "dfca6a2923cbc8c272a200490f12ae7e43704a8ebdb378bcaa64acfeb28128b7"));
    });
  });
}