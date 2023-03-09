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

  TransactionRequestEntity({
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
