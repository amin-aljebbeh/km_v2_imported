import 'package:kammun_app/features/admins/data/models/admin_model.dart';
import 'package:kammun_app/features/transactions/domain/entities/admin_transaction_entity.dart';

import 'transaction_category_model.dart';

class AdminTransactionModel extends AdminTransactionEntity {
  AdminTransactionModel({
    id,
    transactionCategoryId,
    adminId,
    orderId,
    value,
    description,
    actorId,
    userId,
    date,
    createdAt,
    companyValue,
    shopperValue,
    category,
    actor,
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
          createdAt: createdAt,
          companyValue: companyValue,
          shopperValue: shopperValue,
          category: category,
          actor: actor,
        );

  factory AdminTransactionModel.fromJson(Map<String, dynamic> json) => AdminTransactionModel(
        userId: json['user_id'],
        id: json['id'],
        companyValue: json['value_company'].toString(),
        shopperValue: json['value_shopper'].toString(),
        actorId: json['actor_id'],
        adminId: json['admin_id'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        description: json['description'],
        orderId: json['order_id'],
        actor: json['actor'] == null ? null : AdminModel.fromJson(json['actor']),
        transactionCategoryId: json['trns_category'],
        category: json['transaction_category'] == null
            ? null
            : TransactionCategoryModel.fromJson(json['transaction_category']),
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
