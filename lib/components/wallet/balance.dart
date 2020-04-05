import 'package:pblcwallet/components/buttons/copy_button.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/utils/eth_amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Balance extends StatelessWidget {
  Balance(this.store);
  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(store.address),
          CopyButton(
            text: const Text('Copy address'),
            value: store.address,
          ),
          QrImage(
            data: store.address,
            size: 150.0,
          ),
          Observer(
              builder: (_) => Text(
                    "${EthAmountFormatter(store.tokenBalance).format()} PBLC",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .apply(fontSizeDelta: 6),
                  )),
          Observer(
              builder: (_) => Text(
                    "${EthAmountFormatter(store.ethBalance).format()} ETH",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .apply(color: Colors.blueGrey),
                  ))
        ],
      ),
    );
  }
}
