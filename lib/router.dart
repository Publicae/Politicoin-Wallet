import 'package:pblcwallet/processing_transaction_page.dart';
import 'package:pblcwallet/qrcode_reader_page.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/stores/wallet_buy_sell_store.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:pblcwallet/wallet_buy_sell_page.dart';
import 'package:pblcwallet/wallet_create_page.dart';
import 'package:pblcwallet/wallet_import_page.dart';
import 'package:pblcwallet/wallet_main_page.dart';
import 'package:pblcwallet/wallet_transactions_page.dart';
import 'package:pblcwallet/wallet_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'intro_page.dart';

Map<String, WidgetBuilder> getRoutes(context) {
  return {
    '/': (BuildContext context) => Consumer<ConfigurationService>(
            builder: (context, configurationService, _) {
          if (configurationService.didSetupWallet())
            return Consumer<WalletStore>(
              builder: (context, walletStore, _) => WalletMainPage(
                walletStore,
                title: "PBLC wallet",
                currentNetwork: configurationService.getNetwork(),
              ),
            );

          return IntroPage();
        }),
    '/create': (BuildContext context) => Consumer<WalletCreateStore>(
          builder: (context, walletCreateStore, _) =>
              WalletCreatePage(walletCreateStore, title: "Create wallet"),
        ),
    '/import': (BuildContext context) => Consumer<WalletImportStore>(
          builder: (context, walletImportStore, _) =>
              WalletImportPage(walletImportStore, title: "Import wallet"),
        ),
    '/transfer': (BuildContext context) => Consumer<WalletTransferStore>(
          builder: (context, walletTransferStore, _) =>
              WalletTransferPage(walletTransferStore, title: "Send PBLC / ETH"),
        ),
    '/processing-transaction': (BuildContext context) =>
        Consumer<WalletTransferStore>(
          builder: (context, walletTransferStore, _) =>
              ProcessingTransactionPage(title: "Waiting..."),
        ),
    '/qrcode_reader': (BuildContext context) => QRCodeReaderPage(
          title: "Scan QRCode",
          onScanned: ModalRoute.of(context).settings.arguments,
        ),
    '/buy-sell': (BuildContext context) => Consumer<WalletBuySellStore>(
          builder: (context, walletBuySellStore, _) =>
              WalletBuySellPage(walletBuySellStore, title: "Buy/Sell PBLC"),
        ),
    '/transactions': (BuildContext context) => Consumer<WalletTransactionsStore>(
          builder: (context, walletTransactionsStore, _) =>
              WalletTransactionsPage(walletTransactionsStore, title: "My Transactions"),
        ),
  };
}
