import 'package:kammun_app/features/transactions/data/models/transaction_request_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_requests_response_entity.dart';
import 'transaction_category_model.dart';

TransactionRequestsResponseModel transactionRequestsResponseModelFromJson(String str) =>
    TransactionRequestsResponseModel.fromJson(json.decode(str));

class TransactionRequestsResponseModel extends TransactionRequestsResponseEntity {
  TransactionRequestsResponseModel({success, data}) : super(success: success, data: data);

  factory TransactionRequestsResponseModel.fromJson(Map<String, dynamic> json) =>
      TransactionRequestsResponseModel(success: json['success'], data: RequestsDataModel.fromJson(json['data']));
}

class RequestsDataModel extends RequestsDataEntity {
  RequestsDataModel({transactionRequest, categoryForFilter})
      : super(categoryForFilter: categoryForFilter, transactionRequest: transactionRequest);

  factory RequestsDataModel.fromJson(Map<String, dynamic> json) => RequestsDataModel(
        transactionRequest: RequestsPaginationModel.fromJson(json['transaction_request']),
        categoryForFilter: List<TransactionCategoryModel>.from(
            json['category_for_filter'].map((x) => TransactionCategoryModel.fromJson(x))),
      );
}

class RequestsPaginationModel extends RequestsPaginationEntity {
  RequestsPaginationModel({
    currentPage,
    requests,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total,
  }) : super(
          currentPage: currentPage,
          requests: requests,
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

  factory RequestsPaginationModel.fromJson(Map<String, dynamic> json) => RequestsPaginationModel(
        currentPage: json['current_page'],
        requests: List<TransactionRequestModel>.from(json['data'].map((x) => TransactionRequestModel.fromJson(x))),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}
