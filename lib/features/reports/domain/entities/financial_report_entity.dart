import 'package:kammun_app/features/reports/domain/entities/report_data_entity.dart';

class FinancialReportEntity {
  FinancialReportEntity({this.success, this.data});

  bool success;
  ReportDataEntity data;
}
