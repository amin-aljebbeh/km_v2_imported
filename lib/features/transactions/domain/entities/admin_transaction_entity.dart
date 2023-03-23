import '../../../admins/domain/entities/admins_entity.dart';
import 'transaction_category_entity.dart';

class AdminTransactionEntity {
  final int id;
  final int transactionCategoryId;
  final int adminId;
  final int orderId;
  final int value;
  final int companyValue;
  final int shopperValue;
  final String description;
  final int actorId;
  final int userId;
  final String date;
  final DateTime createdAt;
  final TransactionCategoryEntity category;
  final AdminEntity actor;

  AdminTransactionEntity({
    this.companyValue,
    this.actor,
    this.shopperValue,
    this.id,
    this.transactionCategoryId,
    this.adminId,
    this.orderId,
    this.value,
    this.description,
    this.actorId,
    this.userId,
    this.date,
    this.createdAt,
    this.category,
  });
}
