import 'package:kammun_app/core/core_importer.dart';

import '../../shoppers_reports/data/models/activity_hours_model.dart';
import '../../shoppers_reports/data/models/shopper_monthly_report_model.dart';
import '../../shoppers_reports/data/models/shopper_working_hours_model.dart';

class ReportsServices {
  static Future<ActivityHours> getShopperActivityHours({String shopperId, String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: shopperActivityHoursApi + shopperId,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);

    if (response.statusCode == successCode) return activityHoursFromJson(jsonEncode(response.data));
    return null;
  }

  static Future<List<ShopperWorkingHoursModel>> getShopperWorkingHours({String shopperId, String filterBy}) async {
    Response response;
    response = await ApiProvider.sendRequest(
        url: getWorkingHourApi + shopperId,
        queryParameters: {'filter_by': filterBy.split('.')[1]},
        method: HttpMethods.get);

    if (response.statusCode == successCode) return shopperWorkingHoursFromJson(jsonEncode(response.data)).data;
    return null;
  }

  static Future<ShopperMonthlyReportResponse> getMonthlyShopperReports({String shopperId}) async {
    Response response;

    response = await ApiProvider.sendRequest(url: monthlyShopperReportsApi + shopperId, method: HttpMethods.get);

    if (response.statusCode == successCode) return shopperMonthlyReportFromJson(jsonEncode(response.data));
    return null;
  }
}
