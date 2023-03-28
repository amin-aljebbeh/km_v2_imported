// To parse this JSON data, do
//
//     final transactionsResponseModel = transactionsResponseModelFromJson(jsonString);

import 'package:kammun_app/features/transactions/data/models/admin_transaction_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/transactions_response_entity.dart';

TransactionsResponseModel transactionsResponseModelFromJson(String str) =>
    TransactionsResponseModel.fromJson(json.decode(str));

class TransactionsResponseModel extends TransactionsResponseEntity {
  TransactionsResponseModel({success, transactionsPage}) : super(success: success, transactionsPage: transactionsPage);

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) => TransactionsResponseModel(
        success: json['success'],
        transactionsPage: TransactionsPaginationModel.fromJson(json['data']),
      );
}

class TransactionsPaginationModel extends TransactionsPaginationEntity {
  TransactionsPaginationModel({
    currentPage,
    transactions,
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
          transactions: transactions,
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
        currentPage: json['current_page'],
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        transactions: List<AdminTransactionModel>.from(json['data'].map((x) => AdminTransactionModel.fromJson(x))),
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );
}
