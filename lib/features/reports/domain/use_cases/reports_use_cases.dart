import '../../../../core/core_importer.dart';
import 'get_financial_report_use_case.dart';
import 'get_sales_reports_use_case.dart';

class ReportsUseCases {
  final GetFinancialReportUseCase getFinancialReportUseCase;
  final GetSalesReportsUseCase getSalesReportsUseCase;

  ReportsUseCases({@required this.getFinancialReportUseCase, @required this.getSalesReportsUseCase})
      : assert(getSalesReportsUseCase != null && getFinancialReportUseCase != null,
            'All use cases should ne initialized.');
}
