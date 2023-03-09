import 'package:kammun_app/features/transactions/domain/entities/admin_transaction_entity.dart';

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
        );

  factory AdminTransactionModel.fromJson(Map<String, dynamic> json) => AdminTransactionModel(
        userId: json['user_id'],
        id: json['id'],
        companyValue: json['value_company'],
        shopperValue: json['value_shopper'],
        actorId: json['actor_id'],
        adminId: json['admin_id'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        description: json['description'],
        orderId: json['order_id'],
        transactionCategoryId: json['trns_category_id'],
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
