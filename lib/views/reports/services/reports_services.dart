import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/reports/models/sailes_reports_model.dart';

class ReportsServcies {
  static Future<GetDailyStatistics> getSailesReports(
      {String fromDate, String toDate, String warehouseId}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_DAILY_STATISTICS,
      queryParameters: {
        "warehouse_id": warehouseId,
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
}
