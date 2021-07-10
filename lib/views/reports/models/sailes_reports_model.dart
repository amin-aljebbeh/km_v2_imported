// To parse this JSON data, do
//
//     final getDailyStatistics = getDailyStatisticsFromJson(jsonString);

import 'dart:convert';

GetDailyStatistics getDailyStatisticsFromJson(String str) =>
    GetDailyStatistics.fromJson(json.decode(str));

String getDailyStatisticsToJson(GetDailyStatistics data) =>
    json.encode(data.toJson());

class GetDailyStatistics {
  GetDailyStatistics({
    this.success,
    this.data,
    this.date,
  });

  bool success;
  List<Datum> data;
  Date date;

  factory GetDailyStatistics.fromJson(Map<String, dynamic> json) =>
      GetDailyStatistics(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "date": date == null ? null : date.toJson(),
      };
}

class Datum {
  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        numberOfWorkers: json["number_of_workers"] == null
            ? null
            : json["number_of_workers"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        statisticsWarehouses: json["statistics_warehouses"] == null
            ? null
            : StatisticsWarehouses.fromJson(json["statistics_warehouses"]),
        statisticsSubWarehouses: json["statistics_sub_warehouses"] == null
            ? null
            : List<StatisticsSubWarehouse>.from(
                json["statistics_sub_warehouses"]
                    .map((x) => StatisticsSubWarehouse.fromJson(x))),
        statisticsSupportedCities: json["statistics_supported_cities"] == null
            ? null
            : List<StatisticsSupportedCity>.from(
                json["statistics_supported_cities"]
                    .map((x) => StatisticsSupportedCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "number_of_workers": numberOfWorkers == null ? null : numberOfWorkers,
        "is_active": isActive == null ? null : isActive,
        "statistics_warehouses":
            statisticsWarehouses == null ? null : statisticsWarehouses.toJson(),
        "statistics_sub_warehouses": statisticsSubWarehouses == null
            ? null
            : List<dynamic>.from(
                statisticsSubWarehouses.map((x) => x.toJson())),
        "statistics_supported_cities": statisticsSupportedCities == null
            ? null
            : List<dynamic>.from(
                statisticsSupportedCities.map((x) => x.toJson())),
      };
}

class StatisticsSubWarehouse {
  StatisticsSubWarehouse({
    this.warehouseId,
    this.subWarehouseId,
    this.name,
    this.businessDomain,
    this.sumPurchasePrice,
  });

  int warehouseId;
  int subWarehouseId;
  String name;
  String businessDomain;
  String sumPurchasePrice;

  factory StatisticsSubWarehouse.fromJson(Map<String, dynamic> json) =>
      StatisticsSubWarehouse(
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
        name: json["name"] == null ? null : json["name"],
        businessDomain:
            json["business_domain"] == null ? null : json["business_domain"],
        sumPurchasePrice: json["sum_purchase_price"] == null
            ? null
            : json["sum_purchase_price"],
      );

  Map<String, dynamic> toJson() => {
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
        "name": name == null ? null : name,
        "business_domain": businessDomain == null ? null : businessDomain,
        "sum_purchase_price":
            sumPurchasePrice == null ? null : sumPurchasePrice,
      };
}

class StatisticsSupportedCity {
  StatisticsSupportedCity({
    this.supportedCityId,
    this.name,
    this.deliveryIncome,
    this.ordersCount,
    this.deliveryPrice,
  });

  int supportedCityId;
  String name;
  String deliveryIncome;
  int ordersCount;
  String deliveryPrice;

  factory StatisticsSupportedCity.fromJson(Map<String, dynamic> json) =>
      StatisticsSupportedCity(
        supportedCityId: json["supported_city_id"] == null
            ? null
            : json["supported_city_id"],
        name: json["name"] == null ? null : json["name"],
        deliveryIncome:
            json["delivery_income"] == null ? null : json["delivery_income"],
        ordersCount: json["orders_count"] == null ? null : json["orders_count"],
        deliveryPrice:
            json["delivery_price"] == null ? null : json["delivery_price"],
      );

  Map<String, dynamic> toJson() => {
        "supported_city_id": supportedCityId == null ? null : supportedCityId,
        "name": name == null ? null : name,
        "delivery_income": deliveryIncome == null ? null : deliveryIncome,
        "orders_count": ordersCount == null ? null : ordersCount,
        "delivery_price": deliveryPrice == null ? null : deliveryPrice,
      };
}

class StatisticsWarehouses {
  StatisticsWarehouses({
    this.totalSales,
    this.deliveryIncome,
    this.total,
  });

  int totalSales;
  int deliveryIncome;
  int total;

  factory StatisticsWarehouses.fromJson(Map<String, dynamic> json) =>
      StatisticsWarehouses(
        totalSales: json["total_sales"] == null ? null : json["total_sales"],
        deliveryIncome:
            json["delivery_income"] == null ? null : json["delivery_income"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total_sales": totalSales == null ? null : totalSales,
        "delivery_income": deliveryIncome == null ? null : deliveryIncome,
        "total": total == null ? null : total,
      };
}

class Date {
  Date({
    this.fromDate,
    this.toDate,
  });

  DateTime fromDate;
  DateTime toDate;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        fromDate: json["from_date"] == null
            ? null
            : DateTime.parse(json["from_date"]),
        toDate:
            json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
      );

  Map<String, dynamic> toJson() => {
        "from_date": fromDate == null ? null : fromDate.toIso8601String(),
        "to_date": toDate == null ? null : toDate.toIso8601String(),
      };
}
