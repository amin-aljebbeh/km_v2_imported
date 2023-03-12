import 'package:kammun_app/features/transactions/domain/entities/transaction_operation_entity.dart';

class TransactionOperationModel extends TransactionOperationEntity {
  TransactionOperationModel({id, label, affectAdmin, affectActor, affectUser, affectShopper})
      : super(
          id: id,
          label: label,
          affectActor: affectActor,
          affectAdmin: affectAdmin,
          affectShopper: affectShopper,
          affectUser: affectUser,
        );

  factory TransactionOperationModel.fromJson(Map<String, dynamic> json) => TransactionOperationModel(
        id: json['id'],
        label: json['label'],
        affectAdmin: json['affecte_admin'],
        affectActor: json['affecte_actor'],
        affectUser: json['affecte_user'],
        affectShopper: json['affecte_shopper'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'affecte_admin': affectAdmin,
        'affecte_actor': affectActor,
        'affecte_user': affectUser,
        'affecte_shopper': affectShopper,
      };
}
