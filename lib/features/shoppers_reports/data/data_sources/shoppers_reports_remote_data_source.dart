import '../../../../core/core_importer.dart';
import '../models/activity_hours_model.dart';
import '../models/shopper_monthly_report_model.dart';
import '../models/shopper_working_hours_model.dart';

abstract class ShoppersReportsRemoteDataSource {
  Future<List<ActivityHoursModel>> getShopperActivityHours({String shopperId, String fromDate, String toDate});

  Future<List<ShopperWorkingHoursModel>> getShopperWorkingHours({String shopperId, String filterBy});

  Future<List<ShopperMonthlyReportModel>> getMonthlyShopperReports({String shopperId});
}

class ShoppersReportsRemoteDataSourceImplement implements ShoppersReportsRemoteDataSource {
  @override
  Future<List<ShopperMonthlyReportModel>> getMonthlyShopperReports({String shopperId}) async {
    Response response =
        await ApiProvider.sendRequest(url: monthlyShopperReportsApi + shopperId, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return shopperMonthlyReportFromJson(jsonEncode(response.data)).shopperMonthlyReport;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ActivityHoursModel>> getShopperActivityHours({String shopperId, String fromDate, String toDate}) async {
    Response response = await ApiProvider.sendRequest(
        url: shopperActivityHoursApi + shopperId,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return activityHoursFromJson(jsonEncode(response.data)).data;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ShopperWorkingHoursModel>> getShopperWorkingHours({String shopperId, String filterBy}) async {
    Response response = await ApiProvider.sendRequest(
        url: getWorkingHourApi + shopperId,
        queryParameters: {'filter_by': filterBy.split('.')[1]},
        method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return shopperWorkingHoursFromJson(jsonEncode(response.data)).data;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
