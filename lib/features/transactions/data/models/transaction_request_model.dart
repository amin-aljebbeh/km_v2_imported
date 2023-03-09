import '../../domain/entities/transaction_request_entity.dart';

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
        );

  factory TransactionRequestModel.fromJson(Map<String, dynamic> json) => TransactionRequestModel(
        id: json['id'],
        categoryId: json['trns_category_id'],
        creatorId: json['creator_id'],
        value: json['value'],
        orderId: json['order_id'],
        actorId: json['actor_id'],
        description: json['description'],
        statusId: json['trns_status_id'],
        rejectReason: json['reject_reasun'],
        changedBy: json['changed_by'],
        transactionId: json['trns_id'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );
}
