// To parse this JSON data, do
//
//     final transactionsModel = transactionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

TransactionsModel transactionsModelFromJson(String str) => TransactionsModel.fromJson(json.decode(str));

String transactionsModelToJson(TransactionsModel data) => json.encode(data.toJson());

class TransactionsModel {
    String status;
    String message;
    List<TransactionModel> transactions;

    TransactionsModel({
        this.status,
        this.message,
        this.transactions,
    });

    factory TransactionsModel.fromJson(Map<String, dynamic> json) => TransactionsModel(
        status: json["status"],
        message: json["message"],
        transactions: List<TransactionModel>.from(json["result"].map((x) => TransactionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(transactions.map((x) => x.toJson())),
    };
}

class TransactionModel {
    String blockNumber;
    String timeStamp;
    String hash;
    String nonce;
    String blockHash;
    String transactionIndex;
    String from;
    String to;
    String value;
    String gas;
    String gasPrice;
    String isError;
    String txreceiptStatus;
    String input;
    String contractAddress;
    String cumulativeGasUsed;
    String gasUsed;
    String confirmations;

    TransactionModel({
        this.blockNumber,
        this.timeStamp,
        this.hash,
        this.nonce,
        this.blockHash,
        this.transactionIndex,
        this.from,
        this.to,
        this.value,
        this.gas,
        this.gasPrice,
        this.isError,
        this.txreceiptStatus,
        this.input,
        this.contractAddress,
        this.cumulativeGasUsed,
        this.gasUsed,
        this.confirmations,
    });

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        blockNumber: json["blockNumber"],
        timeStamp: json["timeStamp"],
        hash: json["hash"],
        nonce: json["nonce"],
        blockHash: json["blockHash"],
        transactionIndex: json["transactionIndex"],
        from: json["from"],
        to: json["to"],
        value: json["value"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        isError: json["isError"],
        txreceiptStatus: json["txreceipt_status"],
        input: json["input"],
        contractAddress: json["contractAddress"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        gasUsed: json["gasUsed"],
        confirmations: json["confirmations"],
    );

    Map<String, dynamic> toJson() => {
        "blockNumber": blockNumber,
        "timeStamp": timeStamp,
        "hash": hash,
        "nonce": nonce,
        "blockHash": blockHash,
        "transactionIndex": transactionIndex,
        "from": from,
        "to": to,
        "value": value,
        "gas": gas,
        "gasPrice": gasPrice,
        "isError": isError,
        "txreceipt_status": txreceiptStatus,
        "input": input,
        "contractAddress": contractAddress,
        "cumulativeGasUsed": cumulativeGasUsed,
        "gasUsed": gasUsed,
        "confirmations": confirmations,
    };

    String formattedDate() {
      var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp) * 1000);
      return DateFormat.yMMMMd().add_jm().format(date);
    } 
}
