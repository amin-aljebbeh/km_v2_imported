import '../../domain/entities/report_data_entity.dart';
import 'financial_warehouse_model.dart';
import 'general_info_model.dart';

class ReportDataModel extends ReportDataEntity {
  ReportDataModel({general, warehouses}) : super(warehouses: warehouses, general: general);

  factory ReportDataModel.fromJson(Map<String, dynamic> json) => ReportDataModel(
        general: GeneralInfoModel.fromJson(json['general']),
        warehouses:
            List<FinancialWarehouseModel>.from(json['warehouses'].map((x) => FinancialWarehouseModel.fromJson(x))),
      );
}
