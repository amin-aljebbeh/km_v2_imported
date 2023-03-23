import 'package:kammun_app/features/transactions/data/models/transaction_request_model.dart';

import 'transaction_category_entity.dart';

class TransactionRequestsResponseEntity {
  TransactionRequestsResponseEntity({this.success, this.data});

  bool success;
  RequestsDataEntity data;
}

class RequestsDataEntity {
  RequestsDataEntity({this.transactionRequest, this.categoryForFilter});

  RequestsPaginationEntity transactionRequest;
  List<TransactionCategoryEntity> categoryForFilter;
}

class RequestsPaginationEntity {
  RequestsPaginationEntity({
    this.currentPage,
    this.requests,
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
  List<TransactionRequestModel> requests;
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
}
