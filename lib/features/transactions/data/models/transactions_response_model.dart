// To parse this JSON data, do
//
//     final transactionsResponseModel = transactionsResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/transactions_response_entity.dart';

TransactionsResponseModel transactionsResponseModelFromJson(String str) =>
    TransactionsResponseModel.fromJson(json.decode(str));

class TransactionsResponseModel extends TransactionsResponseEntity {
  TransactionsResponseModel({success, transactionsPage});

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) => TransactionsResponseModel(
        success: json["success"],
        transactionsPage: TransactionsPaginationModel.fromJson(json["data"]),
      );
}

class TransactionsPaginationModel extends TransactionsPaginationEntity {
  TransactionsPaginationModel({
    currentPage,
    data,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    links,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total,
  }) : super(
          currentPage: currentPage,
          firstPageUrl: firstPageUrl,
          from: from,
          lastPage: lastPage,
          lastPageUrl: lastPageUrl,
          nextPageUrl: nextPageUrl,
          path: path,
          perPage: perPage,
          prevPageUrl: prevPageUrl,
          to: to,
          total: total,
        );

  factory TransactionsPaginationModel.fromJson(Map<String, dynamic> json) => TransactionsPaginationModel(
        currentPage: json["current_page"],
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
}
