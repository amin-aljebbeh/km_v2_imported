import 'package:kammun_app/core/core_importer.dart';

import '../models/activity_hours_model.dart';
import '../models/report_model_importer.dart';
import '../models/shopper_monthly_report_model.dart';
import '../models/shopper_working_hours_model.dart';

class ReportsServices {
  static Future<GetDailyStatistics> getSalesReports({String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: getDailyStatistics, queryParameters: {'from_date': fromDate, 'to_date': toDate}, method: HttpMethods.get);

    if (response.statusCode == successCode) return getDailyStatisticsFromJson(jsonEncode(response.data));
    return null;
  }

  static Future<FinancialReport> getFinancialReport({String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: financialReportUrl, queryParameters: {'from_date': fromDate, 'to_date': toDate}, method: HttpMethods.get);

    if (response.statusCode == successCode) return financialReportFromJson(jsonEncode(response.data));
    return null;
  }

  static Future<ActivityHours> getShopperActivityHours({String shopperId, String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: shopperActivityHours + shopperId,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);

    if (response.statusCode == successCode) return activityHoursFromJson(jsonEncode(response.data));
    return null;
  }

  static Future<List<ShopperWorkingHoursData>> getShopperWorkingHours({String shopperId, String filterBy}) async {
    Response response;
    response = await ApiProvider.sendRequest(
        url: getWorkingHour + shopperId,
        queryParameters: {'filter_by': filterBy.split('.')[1]},
        method: HttpMethods.get);

    if (response.statusCode == successCode) return shopperWorkingHoursFromJson(jsonEncode(response.data)).data;
    return null;
  }

  static Future<ShopperMonthlyReportResponse> getMonthlyShopperReports({String shopperId}) async {
    Response response;

    response = await ApiProvider.sendRequest(url: monthlyShopperReports + shopperId, method: HttpMethods.get);

    if (response.statusCode == successCode) return shopperMonthlyReportFromJson(jsonEncode(response.data));
    return null;
  }

  static Future<List<SupplierAccountModel>> getSupplierAccounts({String fromDate, String toDate}) async {
    try {
      Response response;
      response = await ApiProvider.sendRequest(
          url: remainingMoneyForSupplierApi,
          queryParameters: {'from_date': fromDate, 'to_date': toDate},
          method: HttpMethods.get);

      if (response.statusCode == successCode) {
        return supplierAccountModelResponseFromJson(jsonEncode(response.data)).data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
