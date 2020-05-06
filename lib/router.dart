import 'package:get/get.dart';
import 'package:pblcwallet/login_page.dart';
import 'package:pblcwallet/processing_transaction_page.dart';
import 'package:pblcwallet/qrcode_reader_page.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/settings_page.dart';
import 'package:pblcwallet/stores/login_store.dart';
import 'package:pblcwallet/stores/settings_store.dart';
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

Map<String, GetRoute> getRoutes(BuildContext context) {
  return {
    '/': GetRoute(
      page: Consumer<LoginStore>(
        builder: (context, loginStore, _) =>
            LoginPage(loginStore, title: "Login"),
      ),
    ),
    '/main-page': GetRoute(
      page: Consumer<ConfigurationService>(
        builder: (context, configurationService, _) => Consumer<WalletStore>(
          builder: (context, walletStore, _) => WalletMainPage(
            walletStore,
            title: "PBLC Wallet",
            currentNetwork: configurationService.getNetwork(),
          ),
        ),
      ),
    ),
    '/create': GetRoute(
      page: Consumer<WalletCreateStore>(
        builder: (context, walletCreateStore, _) =>
            WalletCreatePage(walletCreateStore, title: "PBLC wallet"),
      ),
    ),
    '/import': GetRoute(
      page: Consumer<WalletImportStore>(
        builder: (context, walletImportStore, _) =>
            WalletImportPage(walletImportStore, title: "PBLC Wallet"),
      ),
    ),
    '/transfer': GetRoute(
      page: Consumer<WalletTransferStore>(
        builder: (context, walletTransferStore, _) =>
            WalletTransferPage(walletTransferStore, title: "Send PBLC / ETH"),
      ),
    ),
    '/processing-transaction': GetRoute(
      page: Consumer<WalletTransferStore>(
        builder: (context, walletTransferStore, _) =>
            ProcessingTransactionPage(title: "Waiting..."),
      ),
    ),
    '/qrcode_reader': GetRoute(
      page: Builder(
        builder: (_) => QRCodeReaderPage(
          title: "Scan",
          onScanned: Get.arguments,
        ),
      ),
    ),
    '/buy-sell': GetRoute(
      page: Consumer<WalletBuySellStore>(
        builder: (context, walletBuySellStore, _) =>
            WalletBuySellPage(walletBuySellStore, title: "Buy/Sell PBLC"),
      ),
    ),
    '/transactions': GetRoute(
      page: Consumer<WalletTransactionsStore>(
        builder: (context, walletTransactionsStore, _) =>
            WalletTransactionsPage(walletTransactionsStore,
                title: "Transactions"),
      ),
    ),
    '/settings': GetRoute(
      page: Consumer<ConfigurationService>(
        builder: (context, configurationService, _) => Consumer<SettingsStore>(
          builder: (context, store, _) => SettingsPage(
            store,
            title: "Settings",
            currentNetwork: configurationService.getNetwork(),
          ),
        ),
      ),
    ),
  };
}
