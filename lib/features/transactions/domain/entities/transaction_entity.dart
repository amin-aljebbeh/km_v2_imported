class TransactionEntity {
  final int id;
  final int transactionCategoryId;
  final int adminId;
  final int orderId;
  final int value;
  final String description;
  final int actorId;
  final int userId;
  final String date;

  TransactionEntity({
    this.id,
    this.transactionCategoryId,
    this.adminId,
    this.orderId,
    this.value,
    this.description,
    this.actorId,
    this.userId,
    this.date,
  });
}
