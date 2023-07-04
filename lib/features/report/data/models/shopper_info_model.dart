import '../../domain/entities/shopper_info_entity.dart';

class ShopperInfoModel extends ShopperInfoEntity {
  ShopperInfoModel({shopperId, name, companyDues, totalProfits, avgDeliveryMinutes, avgOrderRating})
      : super(
          shopperId: shopperId,
          name: name,
          companyDues: companyDues,
          totalProfits: totalProfits,
          avgDeliveryMinutes: avgDeliveryMinutes,
          avgOrderRating: avgOrderRating,
        );

  factory ShopperInfoModel.fromJson(Map<String, dynamic> json) => ShopperInfoModel(
        shopperId: json['shopper_id'],
        name: json['name'],
        companyDues: json['company_dues'],
        totalProfits: json['total_profits'],
        avgDeliveryMinutes: json['avg_delivery_minutes'],
        avgOrderRating: json['avg_order_rating'],
      );

  Map<String, dynamic> toJson() => {
        'shopper_id': shopperId,
        'name': name,
        'company_dues': companyDues,
        'total_profits': totalProfits,
        'avg_delivery_minutes': avgDeliveryMinutes,
        'avg_order_rating': avgOrderRating,
      };
}
