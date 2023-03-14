import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

import 'transaction_request_status_entity.dart';

class TransactionRequestEntity {
  final int id;
  final int categoryId;
  final int creatorId;
  final int value;
  final int orderId;
  final int actorId;
  final String description;
  final int statusId;
  final String rejectReason;
  final int changedBy;
  final int transactionId;
  final DateTime createdAt;
  final TransactionRequestStatusEntity requestStatus;
  final AdminEntity creator;
  final AdminEntity actor;

  TransactionRequestEntity({
    this.requestStatus,
    this.creator,
    this.actor,
    this.id,
    this.categoryId,
    this.creatorId,
    this.value,
    this.orderId,
    this.actorId,
    this.description,
    this.statusId,
    this.rejectReason,
    this.changedBy,
    this.transactionId,
    this.createdAt,
  });
}
