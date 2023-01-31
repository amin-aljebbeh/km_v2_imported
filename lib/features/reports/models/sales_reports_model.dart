// To parse this JSON data, do
//
//     final getDailyStatistics = getDailyStatisticsFromJson(jsonString);   تقرير المبيعات,إحصائيات المبيعات

import 'dart:convert';

GetDailyStatistics getDailyStatisticsFromJson(String str) => GetDailyStatistics.fromJson(json.decode(str));

String getDailyStatisticsToJson(GetDailyStatistics data) => json.encode(data.toJson());

class GetDailyStatistics {
  GetDailyStatistics({this.success, this.generalStatistics, this.warehouses});

  bool success;
  List<WarehouseStatistics> warehouses;
  GeneralStatistics generalStatistics;

  factory GetDailyStatistics.fromJson(Map<String, dynamic> json) => GetDailyStatistics(
        success: json['success'],
        generalStatistics: GeneralStatistics.fromJson(json['general_statistics']),
        warehouses: json['data'] == null
            ? null
            : List<WarehouseStatistics>.from(json['data'].map((x) => WarehouseStatistics.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': warehouses == null ? null : List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}

class GeneralStatistics {
  GeneralStatistics(
      {this.totalShoppingProfits,
      this.totalDeliveryProfits,
      this.totalSales,
      this.sumTips,
      this.totalIncreaseValueProfits});

  int totalShoppingProfits;
  int totalDeliveryProfits;
  int totalSales;
  int sumTips;
  int totalIncreaseValueProfits;

  factory GeneralStatistics.fromJson(Map<String, dynamic> json) => GeneralStatistics(
        totalShoppingProfits: json['total_shopping_profits'],
        totalDeliveryProfits: json['total_delivery_profits'],
        totalSales: json['total_sales'],
        sumTips: json['sum_tips'],
        totalIncreaseValueProfits: json['total_increase_value_profits'],
      );

  Map<String, dynamic> toJson() => {
        'total_shopping_profits': totalShoppingProfits,
        'total_delivery_profits': totalDeliveryProfits,
        'total_sales': totalSales,
      };
}

class WarehouseStatistics {
  WarehouseStatistics({
    this.id,
    this.name,
    this.description,
    this.numberOfWorkers,
    this.isActive,
    this.statisticsWarehouses,
    this.statisticsSubWarehouses,
    this.statisticsSupportedCities,
  });

  int id;
  String name;
  String description;
  int numberOfWorkers;
  int isActive;
  StatisticsWarehouses statisticsWarehouses;
  List<StatisticsSubWarehouse> statisticsSubWarehouses;
  List<StatisticsSupportedCity> statisticsSupportedCities;

  factory WarehouseStatistics.fromJson(Map<String, dynamic> json) => WarehouseStatistics(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        numberOfWorkers: json['number_of_workers'],
        isActive: json['is_active'],
        statisticsWarehouses:
            json['statistics_warehouses'] == null ? null : StatisticsWarehouses.fromJson(json['statistics_warehouses']),
        statisticsSubWarehouses: json['statistics_sub_warehouses'] == null
            ? null
            : List<StatisticsSubWarehouse>.from(
                json['statistics_sub_warehouses'].map((x) => StatisticsSubWarehouse.fromJson(x))),
        statisticsSupportedCities: json['statistics_supported_cities'] == null
            ? null
            : List<StatisticsSupportedCity>.from(
                json['statistics_supported_cities'].map((x) => StatisticsSupportedCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'number_of_workers': numberOfWorkers,
        'is_active': isActive,
        'statistics_warehouses': statisticsWarehouses.toJson(),
        'statistics_sub_warehouses':
            statisticsSubWarehouses == null ? null : List<dynamic>.from(statisticsSubWarehouses.map((x) => x.toJson())),
        'statistics_supported_cities': statisticsSupportedCities == null
            ? null
            : List<dynamic>.from(statisticsSupportedCities.map((x) => x.toJson())),
      };
}

class StatisticsSubWarehouse {
  StatisticsSubWarehouse({
    this.warehouseId,
    this.subWarehouseId,
    this.name,
    this.businessDomain,
    this.sumPurchasePrice,
    this.totalIncreaseValue,
    this.totalShoppingProfits,
  });

  int warehouseId;
  int subWarehouseId;
  String name;
  String businessDomain;
  String sumPurchasePrice;
  String totalIncreaseValue;
  String totalShoppingProfits;

  factory StatisticsSubWarehouse.fromJson(Map<String, dynamic> json) => StatisticsSubWarehouse(
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

class StatisticsSupportedCity {
  StatisticsSupportedCity({this.supportedCityId, this.name, this.deliveryIncome, this.ordersCount, this.deliveryPrice});

  int supportedCityId;
  String name;
  String deliveryIncome;
  int ordersCount;
  String deliveryPrice;

  factory StatisticsSupportedCity.fromJson(Map<String, dynamic> json) => StatisticsSupportedCity(
        supportedCityId: json['supported_city_id'],
        name: json['name'],
        deliveryIncome: json['delivery_income'],
        ordersCount: json['orders_count'],
        deliveryPrice: json['delivery_price'],
      );

  Map<String, dynamic> toJson() => {
        'supported_city_id': supportedCityId,
        'name': name,
        'delivery_income': deliveryIncome,
        'orders_count': ordersCount,
        'delivery_price': deliveryPrice,
      };
}

class StatisticsWarehouses {
  StatisticsWarehouses({
    this.totalSales,
    this.deliveryIncome,
    this.total,
    this.orderCount,
    this.deliveryProfits,
    this.shoppingProfits,
    this.sumTips,
    this.increaseValueProfits,
  });

  int totalSales;
  int deliveryIncome;
  int total;
  int orderCount;
  int shoppingProfits;
  int deliveryProfits;
  int sumTips;
  int increaseValueProfits;

  factory StatisticsWarehouses.fromJson(Map<String, dynamic> json) => StatisticsWarehouses(
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
