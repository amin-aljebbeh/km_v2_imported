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
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : TransactionPage.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
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
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null
            ? null
            : List<TransactionModel>.from(json["data"].map((x) => TransactionModel.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage == null ? null : lastPage,
        "last_page_url": lastPageUrl == null ? null : lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total == null ? null : total,
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
        id: json["id"] == null ? null : json["id"].toString(),
        orderId: json["order_id"] == null ? null : json["order_id"].toString(),
        shopperId: json["shopper_id"] == null ? null : json["shopper_id"].toString(),
        transactionTypeId: json["transaction_type_id"] == null ? null : json["transaction_type_id"].toString(),
        valueShopper: json["value_shopper"] == null ? null : json["value_shopper"].toString(),
        valueCompany: json["value_company"] == null ? null : json["value_company"].toString(),
        description: json["description"] == null ? null : json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order_id": orderId == null ? null : orderId,
        "shopper_id": shopperId == null ? null : shopperId,
        "transaction_type_id": transactionTypeId == null ? null : transactionTypeId,
        "value_shopper": valueShopper == null ? null : valueShopper,
        "value_company": valueCompany == null ? null : valueCompany,
        "description": description == null ? null : description,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
