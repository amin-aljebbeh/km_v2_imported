import 'transaction_operation_entity.dart';

class TransactionCategoryEntity {
  final int id;
  final String name;
  final String slug;
  final int selfTransaction;
  final int requestRequired;
  final int orderRequired;
  final TransactionOperationEntity transactionOperation;

  TransactionCategoryEntity({
    this.id,
    this.selfTransaction,
    this.name,
    this.orderRequired,
    this.requestRequired,
    this.slug,
    this.transactionOperation,
  });
}
