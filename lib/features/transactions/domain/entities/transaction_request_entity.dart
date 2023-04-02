import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

import 'transaction_category_entity.dart';
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
  final TransactionCategoryEntity category;

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
    this.category,
  });

  TransactionRequestEntity copyWith({
    int id,
    int categoryId,
    int creatorId,
    int value,
    int orderId,
    int actorId,
    String description,
    int statusId,
    String rejectReason,
    int changedBy,
    int transactionId,
    DateTime createdAt,
    TransactionRequestStatusEntity requestStatus,
    AdminEntity creator,
    AdminEntity actor,
    TransactionCategoryEntity category,
  }) {
    return TransactionRequestEntity(
      requestStatus: requestStatus ?? this.requestStatus,
      creator: creator ?? this.creator,
      actor: actor ?? this.actor,
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      creatorId: creatorId ?? this.creatorId,
      value: value ?? this.value,
      orderId: orderId ?? this.orderId,
      actorId: actorId ?? this.actorId,
      description: description ?? this.description,
      statusId: statusId ?? this.statusId,
      rejectReason: rejectReason ?? this.rejectReason,
      changedBy: changedBy ?? this.changedBy,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}
