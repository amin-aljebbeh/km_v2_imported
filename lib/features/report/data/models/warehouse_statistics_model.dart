import '../../domain/entities/warehouse_statistics_entity.dart';
import 'statistics_sub_warehouse_model.dart';
import 'statistics_supported_city_model.dart';
import 'statistics_warehouses_model.dart';

class WarehouseStatisticsModel extends WarehouseStatisticsEntity {
  WarehouseStatisticsModel({
    id,
    name,
    description,
    numberOfWorkers,
    isActive,
    statisticsWarehouses,
    statisticsSubWarehouses,
    statisticsSupportedCities,
  }) : super(
          id: id,
          name: name,
          description: description,
          numberOfWorkers: numberOfWorkers,
          isActive: isActive,
          statisticsWarehouses: statisticsWarehouses,
          statisticsSubWarehouses: statisticsSubWarehouses,
          statisticsSupportedCities: statisticsSupportedCities,
        );

  factory WarehouseStatisticsModel.fromJson(Map<String, dynamic> json) => WarehouseStatisticsModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        numberOfWorkers: json['number_of_workers'],
        isActive: json['is_active'],
        statisticsWarehouses: json['statistics_warehouses'] == null
            ? null
            : StatisticsWarehousesModel.fromJson(json['statistics_warehouses']),
        statisticsSubWarehouses: json['statistics_sub_warehouses'] == null
            ? null
            : List<StatisticsSubWarehouseModel>.from(
                json['statistics_sub_warehouses'].map((x) => StatisticsSubWarehouseModel.fromJson(x))),
        statisticsSupportedCities: json['statistics_supported_cities'] == null
            ? null
            : List<StatisticsSupportedCityModel>.from(
                json['statistics_supported_cities'].map((x) => StatisticsSupportedCityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'description': description, 'number_of_workers': numberOfWorkers, 'is_active': isActive};
}
