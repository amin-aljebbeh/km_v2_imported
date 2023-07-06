import 'statistics_sub_warehouse_entity.dart';
import 'statistics_supported_city_entity.dart';
import 'statistics_warehouses_entity.dart';

class WarehouseStatisticsEntity {
  WarehouseStatisticsEntity({
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
  StatisticsWarehousesEntity statisticsWarehouses;
  List<StatisticsSubWarehouseEntity> statisticsSubWarehouses;
  List<StatisticsSupportedCityEntity> statisticsSupportedCities;
}
