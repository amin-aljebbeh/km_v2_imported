import 'transaction_operation_entity.dart';

class TransactionCategoryEntity {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int operationId;
  final int isAuto;
  final int requestRequired;
  final int orderRequired;
  final int parentId;
  final TransactionOperationEntity transactionOperation;

  TransactionCategoryEntity({
    this.id,
    this.name,
    this.orderRequired,
    this.requestRequired,
    this.slug,
    this.description,
    this.operationId,
    this.isAuto,
    this.parentId,
    this.transactionOperation,
  });
}
