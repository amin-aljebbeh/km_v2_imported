import '../../domain/entities/transaction_category_entity.dart';

class TransactionCategoryModel extends TransactionCategoryEntity {
  TransactionCategoryModel({id, name, orderRequired, requestRequired})
      : super(id: id, name: name, orderRequired: orderRequired, requestRequired: requestRequired);

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) => TransactionCategoryModel(
        id: json['id'],
        name: json['name'],
        orderRequired: json['order_required'],
        requestRequired: json['request_required'],
      );
}
