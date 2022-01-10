class TransactionModel {
  final int transactionId;
  final int orderId;
  final int shopperId;
  final String type;
  final double kammunValue;
  final double shopperValue;
  final String description;
  final DateTime date;

  TransactionModel(
    this.transactionId,
    this.orderId,
    this.shopperId,
    this.type,
    this.kammunValue,
    this.shopperValue,
    this.description,
    this.date,
  );
}
