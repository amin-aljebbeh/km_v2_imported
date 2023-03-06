import 'package:kammun_app/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    id,
    transactionCategoryId,
    adminId,
    orderId,
    value,
    description,
    actorId,
    userId,
    date,
  }) : super(
          id: id,
          transactionCategoryId: transactionCategoryId,
          adminId: adminId,
          orderId: orderId,
          value: value,
          description: description,
          actorId: actorId,
          userId: userId,
          date: date,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        userId: json['user_id'],
        id: json['id'],
        value: json['value'],
        actorId: json['actor_id'],
        adminId: json['admin_id'],
        date: json['date'],
        description: json['description'],
        orderId: json['order_id'],
        transactionCategoryId: json['transaction_category_id'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'id': id,
        'value': value,
        'actor_id': actorId,
        'admin_id': adminId,
        'date': date,
        'description': description,
        'order_id': orderId,
        'transaction_category_id': transactionCategoryId,
      };
}
