import '../../../../core/core_importer.dart';

class CouponEntity extends Equatable {
  final int id;
  final String code;
  final DateTime expirationDate;
  final int expirationPeriod;
  final String description;
  final String descriptionUser;
  final String msgContent;
  final int maxOrders;
  final int amount;
  final int minCost;
  final int maxCost;
  final int usageLimit;
  final int userUsageLimit;
  final int isPercentageCoupon;
  final int isForDelivery;
  final int isGeneral;
  final int isActive;
  final int isAllCity;
  final PivotEntity pivot;

  const CouponEntity({
    this.expirationPeriod,
    this.pivot,
    this.description,
    this.msgContent,
    this.maxOrders,
    this.amount,
    this.minCost,
    this.maxCost,
    this.usageLimit,
    this.userUsageLimit,
    this.isPercentageCoupon,
    this.isForDelivery,
    this.isGeneral,
    this.isAllCity,
    this.id,
    this.code,
    this.expirationDate,
    this.descriptionUser,
    this.isActive,
  });

  @override
  List<Object> get props => [
        expirationPeriod,
        description,
        msgContent,
        maxOrders,
        amount,
        minCost,
        maxCost,
        usageLimit,
        userUsageLimit,
        isPercentageCoupon,
        isForDelivery,
        isGeneral,
        isAllCity,
        id,
        pivot,
        code,
        expirationDate,
        descriptionUser,
        isActive,
      ];
}

class PivotEntity {
  PivotEntity({
    this.userId,
    this.couponId,
    this.availability,
    this.nUsage,
    this.usageExpiration,
    this.createdAt,
    this.updatedAt,
  });

  int userId;
  int couponId;
  int availability;
  int nUsage;
  DateTime usageExpiration;
  DateTime createdAt;
  DateTime updatedAt;
}
