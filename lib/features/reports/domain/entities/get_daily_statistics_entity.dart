import 'package:kammun_app/features/reports/domain/entities/general_statistics_entity.dart';
import 'package:kammun_app/features/reports/domain/entities/warehouse_statistics_entity.dart';

class DailyStatisticsEntity {
  DailyStatisticsEntity({this.success, this.generalStatistics, this.warehouses});

  bool success;
  List<WarehouseStatisticsEntity> warehouses;
  GeneralStatisticsEntity generalStatistics;
}
