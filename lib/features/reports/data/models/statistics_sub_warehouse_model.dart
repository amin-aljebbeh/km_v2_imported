import '../../domain/entities/statistics_sub_warehouse_entity.dart';

class StatisticsSubWarehouseModel extends StatisticsSubWarehouseEntity {
  StatisticsSubWarehouseModel(
      {warehouseId, subWarehouseId, name, businessDomain, sumPurchasePrice, totalIncreaseValue, totalShoppingProfits})
      : super(
          warehouseId: warehouseId,
          subWarehouseId: subWarehouseId,
          name: name,
          businessDomain: businessDomain,
          sumPurchasePrice: sumPurchasePrice,
          totalIncreaseValue: totalIncreaseValue,
          totalShoppingProfits: totalShoppingProfits,
        );

  factory StatisticsSubWarehouseModel.fromJson(Map<String, dynamic> json) => StatisticsSubWarehouseModel(
        warehouseId: json['warehouse_id'],
        subWarehouseId: json['sub_warehouse_id'],
        name: json['name'],
        businessDomain: json['business_domain'],
        sumPurchasePrice: json['sum_purchase_price'],
        totalIncreaseValue: json['sum_increase_value'],
        totalShoppingProfits: json['total_shopping_profits'],
      );

  Map<String, dynamic> toJson() => {
        'warehouse_id': warehouseId,
        'sub_warehouse_id': subWarehouseId,
        'name': name,
        'business_domain': businessDomain,
        'sum_purchase_price': sumPurchasePrice,
      };
}
