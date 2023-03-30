import 'package:kammun_app/features/transactions/domain/entities/admin_transaction_entity.dart';

class TransactionsResponseEntity {
  TransactionsResponseEntity({this.success, this.transactionsPage});

  bool success;
  TransactionsPaginationEntity transactionsPage;
}

class TransactionsPaginationEntity {
  TransactionsPaginationEntity({
    this.currentPage,
    this.transactions,
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
  List<AdminTransactionEntity> transactions;
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
