import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/reports/models/matching_report_model.dart';
import 'package:kammun_app/views/reports/models/sailes_reports_model.dart';

class ReportsServcies {
  static Future<GetDailyStatistics> getSailesReports(
      {String fromDate, String toDate, String warehouseId}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_DAILY_STATISTICS,
      queryParameters: {
        "from_date": fromDate,
        "to_date": toDate,
      },
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole(response.data);
      return getDailyStatisticsFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<MatchingProducts> getMatchingReport(
      {String reportDate, String toDate, String subWarehouseId}) async {
    var response;
    Tools.logToConsole({
      "sub_warehouse_id": subWarehouseId,
      "report_date": reportDate,
    });
    response = await ApiProvider.sendRequest(
      url: GET_MATCHING_REPORT,
      queryParameters: {
        "sub_warehouse_id": subWarehouseId,
        "report_date": reportDate,
      },
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole(response.data);
      return matchingProductsFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }
}
