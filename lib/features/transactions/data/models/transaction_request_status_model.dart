import '../../domain/entities/transaction_request_status_entity.dart';

class TransactionRequestStatusModel extends TransactionRequestStatusEntity {
  TransactionRequestStatusModel({id, slug}) : super(id: id, slug: slug);

  factory TransactionRequestStatusModel.fromJson(Map<String, dynamic> json) =>
      TransactionRequestStatusModel(id: json['id'], slug: json['slug']);
}
