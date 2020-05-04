import 'package:flutter/material.dart';
import 'package:pblcwallet/components/transactions/transaction_item_row.dart';
import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/model/transactionsModel.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem(
    this.store,
    this.transaction,
  );
  final WalletTransactionsStore store;
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        color: transaction.txreceiptStatus == "0"
            ? Color(0xaaff0000)
            : Color(0xfff6f6f6),
      ),
      height: 360,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    transaction.to == store.walletStore.address
                        ? "RECEIVED"
                        : "SENT",
                    style: TextStyle(
                        color: transaction.txreceiptStatus == "0"
                            ? Color(0xffffffff)
                            : Color(0xff616161),
                        fontSize: 20),
                  ),
                  Text(
                    transaction.formatTxreceiptStatus(),
                    style: TextStyle(
                      color: transaction.txreceiptStatus == "0"
                          ? Color(0xffffffff)
                          : Color(0xff616161),
                      fontSize: transaction.txreceiptStatus == "0" ? 20 : 12,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '${transaction.hash}',
                style: TextStyle(
                    color: transaction.txreceiptStatus == "0"
                        ? Color(0xffffffff)
                        : Color(0xff818181),
                    fontSize: 14),
              ),
            ),
            onTap: () async {
              var network = configurationService.getNetwork();
              var url = 'https://$network.etherscan.io/tx/${transaction.hash}';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          SizedBox(height: 20),
          TransactionItemRow(
            title: 'Block',
            color: Color(0xffededed),
            property: transaction.blockNumber,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0)),
          ),
          TransactionItemRow(
              title: 'From',
              color: Color(0xfff3f3f3),
              property: transaction.from,
              copy: true),
          TransactionItemRow(
              title: 'To',
              color: Color(0xffededed),
              property: transaction.to,
              copy: true),
          TransactionItemRow(
            title: 'Date',
            color: Color(0xfff3f3f3),
            property: transaction.formattedDate(),
          ),
          TransactionItemRow(
            title: 'Amount',
            color: Color(0xffededed),
            property: transaction.formattedValue(),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0)),
          ),
        ],
      ),
    );
  }
}

/**
 * 
 * 
 *         // Card(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       ListTile(
        //         leading: Icon(Icons.album),
        //         title:
        //             Text('${transaction.hash}', style: TextStyle(fontSize: 14)),
        //         subtitle: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Text('blockNumber: ${transaction.blockNumber}'),
        //             Text('amount: ${showAmount(transaction.value)}'),
        //             Text('from: ${transaction.from}'),
        //             Text('to: ${transaction.to}'),
        //             Text('${transaction.formattedDate()}')
        //           ],
        //         ),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: <Widget>[
        //           Text(transaction.txreceiptStatus == ""
        //               ? "pending"
        //               : "confirmed"),
        //           Text(transaction.to == store.walletStore.address
        //               ? "RECEIVED"
        //               : "SENT")
        //         ],
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: <Widget>[
        //           CopyButton(
        //             text: const Text('Copy From'),
        //             value: transaction.from,
        //           ),
        //           CopyButton(
        //             text: const Text('Copy To'),
        //             value: transaction.to,
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
        // ),

 */
