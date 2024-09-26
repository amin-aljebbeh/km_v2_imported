import 'package:kammun_app/features/transactions/data/models/transaction_operation_model.dart';

import '../../domain/entities/transaction_category_entity.dart';

class TransactionCategoryModel extends TransactionCategoryEntity {
  TransactionCategoryModel({id, name, orderRequired, requestRequired, slug, selfTransaction, transactionOperation})
      : super(
          id: id,
          name: name,
          selfTransaction: selfTransaction,
          orderRequired: orderRequired,
          requestRequired: requestRequired,
          slug: slug,
          transactionOperation: transactionOperation,
        );

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) => TransactionCategoryModel(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        requestRequired: json['request_required'],
        orderRequired: json['order_required'],
        selfTransaction: json['self_transaction'],
        transactionOperation: json['transaction_operation'] != null
            ? TransactionOperationModel.fromJson(json['transaction_operation'])
            : null,
      );
}
