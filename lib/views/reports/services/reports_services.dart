import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import '../models/report_model_importer.dart';

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
      {String shopperId, int pageNumber}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_SHOPPER_TRANSACTIONS + shopperId,
      method: httpMethods.get,
      queryParameters: {"page": pageNumber},
    );

    if (response.statusCode == SUCCESS_CODE) {
      List<TransactionModel> transactions = List<TransactionModel>();
      if (response.data["success"].toString() == "true") {
        transactions =
            transactionResponseFromJson(jsonEncode(response.data)).data.data;
        return transactions;
      } else
        return transactions;
    } else {
      return null;
    }
  }

  static Future<FinancialDuesModel> getShopperFinancialDues(
      {@required String shopperId}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_STATISTICS_SHOPPER_TRANSACTION + shopperId,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE) {
      FinancialDuesModel financialDues = FinancialDuesModel();
      if (response.data["success"].toString() == "true") {
        financialDues =
            financialDuesResponseModelFromJson(jsonEncode(response.data)).data;
        return financialDues;
      } else
        return financialDues;
    } else {
      return null;
    }
  }

  static Future<String> getShopperDailyProfit(
      {@required String shopperId}) async {
    var response;

    response = await ApiProvider.sendRequest(
      url: GET_DAILY_SHOPPER_PROFIT + shopperId,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE) {
      String dailyProfit;
      if (response.data["success"].toString() == "true") {
        dailyProfit =
            dailyProfitModelFromJson(jsonEncode(response.data)).profit;
        return dailyProfit;
      } else
        return dailyProfit;
    } else {
      return null;
    }
  }

  static financialDues(
      {@required BuildContext context, @required String shopperId}) async {
    FinancialDuesModel financialDues =
        await getShopperFinancialDues(shopperId: shopperId);
    Widget content;
    if (financialDues == null)
      content = AlertMessages(
        text: "حدث خطأ اثناء محاولة جلب البيانات",
        messageType: "internetError",
        headerText: "حدث خطأ",
      );
    else
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                StringUtils.shopper,
                style: mainStyle,
              ),
              Text(
                StringUtils()
                    .oCcy
                    .format(int.parse(financialDues.totalShopperProfits).abs())
                    .toString(),
                style: int.parse(financialDues.totalShopperProfits).isNegative
                    ? loseStyle
                    : profitStyle,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                StringUtils.kammun,
                style: mainStyle,
              ),
              Text(
                StringUtils()
                    .oCcy
                    .format(int.parse(financialDues.companyDues).abs())
                    .toString(),
                style: int.parse(financialDues.companyDues).isNegative
                    ? loseStyle
                    : profitStyle,
              ),
            ],
          ),
        ],
      );
    List<DialogButton> dialogButtons = [
      DialogButton(
        text: 'إغلاق',
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    ];
    showMyDialog(
      title: 'المستحقات المالية',
      context: context,
      dialogButtons: dialogButtons,
      content: content,
    );
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

  static Future<bool> addTransaction({
    @required String shopperId,
    @required int transactionType,
    @required String value,
    String orderId,
    String description,
  }) async {
    Map transaction = {
      'shopper_id': shopperId,
      StringUtils.singleTransactionValue[transactionType]: value,
      'order_id': orderId,
      StringUtils.singleTransactionDescription[transactionType]: description,
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: StringUtils.singleTransactionUrls[transactionType],
          method: httpMethods.post,
          body: jsonEncode(transaction));

      if (response.statusCode == SUCCESS_CODE) {
        return response.data['success'];
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return null;
    }
  }
}
