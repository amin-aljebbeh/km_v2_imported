import 'package:kammun_app/features/report/domain/entities/financial_warehouse_entity.dart';
import 'package:kammun_app/features/report/domain/entities/general_info_entity.dart';

class ReportDataEntity {
  ReportDataEntity({this.general, this.warehouses});

  GeneralInfoEntity general;
  List<FinancialWarehouseEntity> warehouses;
}
