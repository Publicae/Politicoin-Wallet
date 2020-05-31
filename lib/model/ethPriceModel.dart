// To parse this JSON data, do
//
//     final ethPriceModel = ethPriceModelFromJson(jsonString);

import 'dart:convert';

EthPriceModel ethPriceModelFromJson(String str) => EthPriceModel.fromJson(json.decode(str));

String ethPriceModelToJson(EthPriceModel data) => json.encode(data.toJson());

class EthPriceModel {
    String status;
    String message;
    Result result;

    EthPriceModel({
        this.status,
        this.message,
        this.result,
    });

    factory EthPriceModel.fromJson(Map<String, dynamic> json) => EthPriceModel(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
    };
}

class Result {
    String ethbtc;
    String ethbtcTimestamp;
    String ethusd;
    String ethusdTimestamp;

    Result({
        this.ethbtc,
        this.ethbtcTimestamp,
        this.ethusd,
        this.ethusdTimestamp,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        ethbtc: json["ethbtc"],
        ethbtcTimestamp: json["ethbtc_timestamp"],
        ethusd: json["ethusd"],
        ethusdTimestamp: json["ethusd_timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "ethbtc": ethbtc,
        "ethbtc_timestamp": ethbtcTimestamp,
        "ethusd": ethusd,
        "ethusd_timestamp": ethusdTimestamp,
    };
}