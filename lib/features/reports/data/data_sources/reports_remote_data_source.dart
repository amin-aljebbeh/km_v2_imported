import '../../../../core/core_importer.dart';
import '../models/financial_report_model.dart';
import '../models/sales_reports_model.dart';

abstract class ReportsRemoteDataSource {
  Future<DailyStatisticsModel> getSalesReports({String fromDate, String toDate});

  Future<FinancialReportModel> getFinancialReport({String fromDate, String toDate});
}

class ReportsRemoteDataSourceImplement implements ReportsRemoteDataSource {
  @override
  Future<FinancialReportModel> getFinancialReport({String fromDate, String toDate}) async {
    Response response = await ApiProvider.sendRequest(
        url: financialReportUrlApi,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return financialReportFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<DailyStatisticsModel> getSalesReports({String fromDate, String toDate}) async {
    Response response = await ApiProvider.sendRequest(
        url: getDailyStatisticsApi,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getDailyStatisticsFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
