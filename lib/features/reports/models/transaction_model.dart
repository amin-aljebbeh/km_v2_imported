// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

TransactionResponse transactionResponseFromJson(String str) => TransactionResponse.fromJson(json.decode(str));

String transactionResponseToJson(TransactionResponse data) => json.encode(data.toJson());

class TransactionResponse {
  TransactionResponse({
    this.success,
    this.data,
  });

  bool success;
  TransactionPage data;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
        success: json["success"],
        data: TransactionPage.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class TransactionPage {
  TransactionPage({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<TransactionModel> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory TransactionPage.fromJson(Map<String, dynamic> json) => TransactionPage(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? null
            : List<TransactionModel>.from(json["data"].map((x) => TransactionModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class TransactionModel {
  TransactionModel({
    this.id,
    this.orderId,
    this.shopperId,
    this.transactionTypeId,
    this.valueShopper,
    this.valueCompany,
    this.description,
    this.createdAt,
  });

  String id;
  String orderId;
  String shopperId;
  String transactionTypeId;
  String valueShopper;
  String valueCompany;
  String description;
  DateTime createdAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json["id"].toString(),
        orderId: json["order_id"].toString(),
        shopperId: json["shopper_id"].toString(),
        transactionTypeId: json["transaction_type_id"].toString(),
        valueShopper: json["value_shopper"].toString(),
        valueCompany: json["value_company"].toString(),
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "shopper_id": shopperId,
        "transaction_type_id": transactionTypeId,
        "value_shopper": valueShopper,
        "value_company": valueCompany,
        "description": description,
        "created_at": createdAt.toIso8601String(),
      };
}
