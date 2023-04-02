import 'package:kammun_app/features/admins/data/models/admin_model.dart';
import 'package:kammun_app/features/transactions/data/models/transaction_request_status_model.dart';

import '../../domain/entities/transaction_request_entity.dart';
import 'transaction_category_model.dart';

class TransactionRequestModel extends TransactionRequestEntity {
  TransactionRequestModel({
    id,
    categoryId,
    creatorId,
    value,
    orderId,
    actorId,
    description,
    statusId,
    rejectReason,
    changedBy,
    transactionId,
    createdAt,
    requestStatus,
    creator,
    actor,
    category,
  }) : super(
          id: id,
          categoryId: categoryId,
          creatorId: creatorId,
          value: value,
          orderId: orderId,
          actorId: actorId,
          description: description,
          statusId: statusId,
          rejectReason: rejectReason,
          changedBy: changedBy,
          transactionId: transactionId,
          createdAt: createdAt,
          actor: actor,
          category: category,
          creator: creator,
          requestStatus: requestStatus,
        );

  factory TransactionRequestModel.fromJson(Map<String, dynamic> json) => TransactionRequestModel(
        id: json['id'],
        actor: json['actor'] == null ? null : AdminModel.fromJson(json['actor']),
        creator: json['creator'] == null ? null : AdminModel.fromJson(json['creator']),
        requestStatus:
            json['requests_status'] == null ? null : TransactionRequestStatusModel.fromJson(json['requests_status']),
        categoryId: json['trns_category_id'],
        creatorId: json['creator_id'],
        value: json['value'],
        orderId: json['order_id'],
        actorId: json['actor_id'],
        description: json['description'],
        statusId: json['trns_status_id'],
        rejectReason: json['reject_reasun'],
        changedBy: json['changed_by'],
        category: json['transaction_category'] == null
            ? null
            : TransactionCategoryModel.fromJson(json['transaction_category']),
        transactionId: json['trns_id'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );
}
