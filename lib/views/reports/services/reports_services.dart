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

    if (response.statusCode == successCode) {
      return getDailyStatisticsFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<FinancialReport> getFinancialReport({String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: financialReportUrl, queryParameters: {'from_date': fromDate, 'to_date': toDate}, method: HttpMethods.get);

    if (response.statusCode == successCode) {
      return financialReportFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<ActivityHours> getShopperActivityHours({String shopperId, String fromDate, String toDate}) async {
    Response response;

    response = await ApiProvider.sendRequest(
        url: shopperActivityHours + shopperId,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
        method: HttpMethods.get);

    if (response.statusCode == successCode) {
      return activityHoursFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<List<ShopperWorkingHoursData>> getShopperWorkingHours({String shopperId, String filterBy}) async {
    Response response;
    response = await ApiProvider.sendRequest(
        url: getWorkingHour + shopperId,
        queryParameters: {'filter_by': filterBy.split('.')[1]},
        method: HttpMethods.get);

    if (response.statusCode == successCode) {
      return shopperWorkingHoursFromJson(jsonEncode(response.data)).data;
    } else {
      return null;
    }
  }

  static Future<ShopperMonthlyReportResponse> getMonthlyShopperReports({String shopperId}) async {
    Response response;

    response = await ApiProvider.sendRequest(url: monthlyShopperReports + shopperId, method: HttpMethods.get);

    if (response.statusCode == successCode) {
      return shopperMonthlyReportFromJson(jsonEncode(response.data));
    } else {
      return null;
    }
  }

  static Future<List<TransactionModel>> getTransactions({String shopperId, int pageNumber}) async {
    try {
      Response response;

      response = await ApiProvider.sendRequest(
          url: getShopperTransactions + shopperId, method: HttpMethods.get, queryParameters: {'page': pageNumber});

      if (response.statusCode == successCode) {
        List<TransactionModel> transactions = [];
        if (response.data['success'].toString() == 'true') {
          transactions = transactionResponseFromJson(jsonEncode(response.data)).data.data;
          return transactions;
        } else {
          return transactions;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<TransactionModel>> getShopperTransaction() async {
    try {
      Response response;

      response = await ApiProvider.sendRequest(url: shopperViewsHisOwnTransactions, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        List<TransactionModel> transactions = [];
        if (response.data['success'].toString() == 'true') {
          transactions = shopperTransactionResponseFromJson(jsonEncode(response.data)).data;
          return transactions;
        } else {
          return transactions;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<FinancialDuesModel> getShopperFinancialDues({@required String shopperId}) async {
    Response response;

    response = await ApiProvider.sendRequest(url: getStatisticsShopperTransaction + shopperId, method: HttpMethods.get);

    if (response.statusCode == successCode) {
      FinancialDuesModel financialDues = FinancialDuesModel();
      if (response.data['success'].toString() == 'true') {
        financialDues = financialDuesResponseModelFromJson(jsonEncode(response.data)).data;
        return financialDues;
      } else {
        return financialDues;
      }
    } else {
      return null;
    }
  }

  static Future<MonthlyProfit> getShopperMonthProfitService({@required String shopperId}) async {
    Response response;

    response = await ApiProvider.sendRequest(url: getShopperMonthProfit + shopperId, method: HttpMethods.get);

    if (response.statusCode == successCode) {
      MonthlyProfit dailyProfit;
      if (response.data['success'].toString() == 'true') {
        dailyProfit = monthlyProfitFromJson(jsonEncode(response.data));
        return dailyProfit;
      } else {
        return dailyProfit;
      }
    } else {
      return null;
    }
  }

  static financialDues({@required BuildContext context, @required String shopperId}) async {
    FinancialDuesModel financialDues = await getShopperFinancialDues(shopperId: shopperId);
    Widget content;
    if (financialDues == null) {
      content = AlertMessages(text: StringUtils.errorMessage, messageType: 'internetError', headerText: 'حدث خطأ');
    } else {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(StringUtils.shopper, style: mainStyle),
              Text(StringUtils().oCcy.format(int.parse(financialDues.totalShopperProfits).abs()).toString(),
                  style: int.parse(financialDues.totalShopperProfits).isNegative ? loseStyle : profitStyle),
            ],
          ),
          Column(
            children: [
              Text(StringUtils.kammun, style: mainStyle),
              Text(StringUtils().oCcy.format(int.parse(financialDues.companyDues).abs()).toString(),
                  style: int.parse(financialDues.companyDues).isNegative ? loseStyle : profitStyle),
            ],
          ),
        ],
      );
    }
    showMyDialog(title: 'المستحقات المالية', dialogButtons: [const CloseWidget()], content: content);
  }

  static Future<bool> addTransactionService({
    @required String shopperId,
    @required String transactionTypeId,
    @required String value,
    String orderId,
    String description,
  }) async {
    Map transaction = {
      'transaction_type_id': transactionTypeId,
      'shopper_id': shopperId,
      'order_id': orderId,
      'value': value,
      'description': description
    };
    try {
      var response =
          await ApiProvider.sendRequest(url: addTransaction, method: HttpMethods.post, body: jsonEncode(transaction));

      if (response.statusCode == successCode) {
        return response.data['success'];
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<TransactionTypeModel>> getTransactionTypes() async {
    try {
      var response = await ApiProvider.sendRequest(url: getTransactionType, method: HttpMethods.get);
      if (response.statusCode == successCode && response.data['success'] == true) {
        return transactionTypeResponseFromJson(jsonEncode(response.data)).data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<SupplierAccountModel>> getSupplierAccounts({String fromDate, String toDate}) async {
    try {
      Response response;
      response = await ApiProvider.sendRequest(
          url: remainingMoneyForSupplier,
          queryParameters: {'from_date': fromDate, 'to_date': toDate},
          method: HttpMethods.get);

      if (response.statusCode == successCode) {
        return supplierAccountModelResponseFromJson(jsonEncode(response.data)).data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
