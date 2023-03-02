import '../../domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
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
    pivot,
  }) : super(
          expirationPeriod: expirationPeriod,
          description: description,
          msgContent: msgContent,
          maxOrders: maxOrders,
          amount: amount,
          minCost: minCost,
          maxCost: maxCost,
          usageLimit: usageLimit,
          userUsageLimit: userUsageLimit,
          isPercentageCoupon: isPercentageCoupon,
          isForDelivery: isForDelivery,
          isGeneral: isGeneral,
          pivot: pivot,
          isAllCity: isAllCity,
          id: id,
          code: code,
          expirationDate: expirationDate,
          descriptionUser: descriptionUser,
          isActive: isActive,
        );

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id'],
        code: json['code'],
        expirationDate: json['expiration_date'] == null ? null : DateTime.parse(json['expiration_date']),
        expirationPeriod: json['expiration_period'],
        description: json['description'],
        descriptionUser: json['description_user'],
        msgContent: json['msg_content'],
        maxOrders: json['max_orders'],
        amount: json['amount'],
        minCost: json['min_cost'],
        maxCost: json['max_cost'],
        usageLimit: json['usage_limit'],
        userUsageLimit: json['user_usage_limit'],
        isPercentageCoupon: json['is_percentage_coupon'],
        isForDelivery: json['is_for_delivery'],
        isGeneral: json['is_general'],
        isActive: json['is_active'],
        isAllCity: json['is_all_city'],
        pivot: json['pivot'] == null ? null : PivotModel.fromJson(json['pivot']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'expiration_date': expirationDate.toIso8601String(),
        'expiration_period': expirationPeriod,
        'description': description,
        'description_user': descriptionUser,
        'msg_content': msgContent,
        'max_orders': maxOrders,
        'amount': amount,
        'min_cost': minCost,
        'max_cost': maxCost,
        'usage_limit': usageLimit,
        'user_usage_limit': userUsageLimit,
        'is_percentage_coupon': isPercentageCoupon,
        'is_for_delivery': isForDelivery,
        'is_general': isGeneral,
        'is_active': isActive,
        'is_all_city': isAllCity,
      };
}

class PivotModel extends PivotEntity {
  PivotModel({
    userId,
    couponId,
    availability,
    nUsage,
    usageExpiration,
    createdAt,
    updatedAt,
  }) : super(
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            availability: availability,
            couponId: couponId,
            nUsage: nUsage,
            usageExpiration: usageExpiration);

  factory PivotModel.fromJson(Map<String, dynamic> json) => PivotModel(
        userId: json['user_id'],
        couponId: json['coupon_id'],
        availability: json['availability'],
        nUsage: json['n_usage'],
        usageExpiration: json['usage_expiration'] == null ? null : DateTime.parse(json['usage_expiration']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'coupon_id': couponId,
        'availability': availability,
        'n_usage': nUsage,
        'usage_expiration': usageExpiration.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
