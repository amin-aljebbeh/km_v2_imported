import '../../domain/entities/general_statistics_entity.dart';

class GeneralStatisticsModel extends GeneralStatisticsEntity {
  GeneralStatisticsModel(
      {totalShoppingProfits, totalDeliveryProfits, totalSales, sumTips, totalIncreaseValueProfits, totalOrders})
      : super(
          totalShoppingProfits: totalShoppingProfits,
          totalDeliveryProfits: totalDeliveryProfits,
          totalSales: totalSales,
          sumTips: sumTips,
          totalIncreaseValueProfits: totalIncreaseValueProfits,
          totalOrders: totalOrders,
        );

  factory GeneralStatisticsModel.fromJson(Map<String, dynamic> json) => GeneralStatisticsModel(
        totalShoppingProfits: json['total_shopping_profits'],
        totalDeliveryProfits: json['total_delivery_profits'],
        totalSales: json['total_sales'],
        sumTips: json['sum_tips'],
        totalIncreaseValueProfits: json['total_increase_value_profits'],
        totalOrders: json['total_orders'],
      );

  Map<String, dynamic> toJson() => {
        'total_shopping_profits': totalShoppingProfits,
        'total_delivery_profits': totalDeliveryProfits,
        'total_sales': totalSales,
      };
}
