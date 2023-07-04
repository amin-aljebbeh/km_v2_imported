import '../../domain/entities/statistics_warehouses_entity.dart';

class StatisticsWarehousesModel extends StatisticsWarehousesEntity {
  StatisticsWarehousesModel(
      {totalSales, deliveryIncome, total, orderCount, deliveryProfits, shoppingProfits, sumTips, increaseValueProfits})
      : super(
          totalSales: totalSales,
          deliveryIncome: deliveryIncome,
          total: total,
          orderCount: orderCount,
          deliveryProfits: deliveryProfits,
          shoppingProfits: shoppingProfits,
          sumTips: sumTips,
          increaseValueProfits: increaseValueProfits,
        );

  factory StatisticsWarehousesModel.fromJson(Map<String, dynamic> json) => StatisticsWarehousesModel(
        totalSales: json['total_sales'],
        deliveryIncome: json['delivery_income'],
        total: json['total'],
        deliveryProfits: json['delivery_profits'],
        orderCount: json['count_orders'],
        shoppingProfits: json['shopping_profits'],
        sumTips: json['sum_tips'],
        increaseValueProfits: json['increase_value_profits'],
      );

  Map<String, dynamic> toJson() => {
        'total_sales': totalSales,
        'delivery_income': deliveryIncome,
        'total': total,
      };
}
