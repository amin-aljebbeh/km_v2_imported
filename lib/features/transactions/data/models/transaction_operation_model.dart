import 'package:kammun_app/features/transactions/domain/entities/transaction_operation_entity.dart';

class TransactionOperationModel extends TransactionOperationEntity {
  TransactionOperationModel({affectActor, affectUser}) : super(affectActor: affectActor, affectUser: affectUser);

  factory TransactionOperationModel.fromJson(Map<String, dynamic> json) =>
      TransactionOperationModel(affectActor: json['affecte_actor'], affectUser: json['affecte_user']);

  Map<String, dynamic> toJson() => {'affecte_actor': affectActor, 'affecte_user': affectUser};
}
