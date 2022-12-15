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

  const CouponEntity({
    this.expirationPeriod,
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
        code,
        expirationDate,
        descriptionUser,
        isActive,
      ];
}
