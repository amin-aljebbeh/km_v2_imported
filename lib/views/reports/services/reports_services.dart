import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/reports/models/matching_report_model.dart';
import 'package:kammun_app/views/reports/models/sales_reports_model.dart';
import 'package:kammun_app/views/reports/models/transaction_model.dart';

class ReportsServices {
  static Future<GetDailyStatistics> getSalesReports(
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

    if (response.statusCode == SUCCESS_CODE) {
      return getDailyStatisticsFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<List<TransactionModel>> getShopperTransactions(
      {String shopperId}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_SHOPPER_TRANSACTIONS + shopperId,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE) {
      if (response.data["success"].toString() == "true") {
        Tools.logToConsole('message from transaction');
        return transactionResponseFromJson(jsonEncode(response.data)).data.data;
      }
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
        response.shopper["success"] == true) {
      Tools.logToConsole(response.shopper);
      return matchingProductsFromJson(jsonEncode(response.shopper));
    } else {
      return null;
    }
  }
}
