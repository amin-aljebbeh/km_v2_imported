import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/reports/add_transaction_view.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import '../../service.dart';
import 'models/monthly_profit_model.dart';
import 'models/transaction_model.dart';

class AccountantTransactionView extends StatefulWidget {
  const AccountantTransactionView({Key key}) : super(key: key);

  @override
  _AccountantTransactionViewState createState() => _AccountantTransactionViewState();
}

class _AccountantTransactionViewState extends State<AccountantTransactionView> {
  bool selected;
  bool error;
  bool empty;
  bool loading;
  bool profitLoading;
  List<TransactionModel> transactions = [];
  String shopperName;
  String shopperId;
  int page;
  MonthlyProfit profit;

  @override
  void initState() {
    page = 1;
    error = false;
    empty = true;
    selected = false;
    loading = false;
    profitLoading = false;
    super.initState();
  }

  Future<List<int>> getCompleteProfits(DateTime date, String shopperId) async {
    List<int> result = [0, 0];
    var tempTransactions = await ReportsServices.getTransactions(shopperId: shopperId, pageNumber: page + 1);
    if (tempTransactions != null) {
      int kammunProfit = tempTransactions
          .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
          .toList()
          .fold(0, (value, transaction) => value + int.parse(transaction.valueCompany));

      int shopperProfit = tempTransactions
          .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
          .toList()
          .fold(0, (value, transaction) => value + int.parse(transaction.valueShopper));
      result[0] += kammunProfit;
      result[1] += shopperProfit;
    }
    if (page > 1) {
      tempTransactions = await ReportsServices.getTransactions(shopperId: shopperId, pageNumber: page - 1);
      if (tempTransactions != null) {
        int kammunProfit = tempTransactions
            .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
            .toList()
            .fold(0, (value, transaction) => value + int.parse(transaction.valueCompany));

        int shopperProfit = tempTransactions
            .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
            .toList()
            .fold(0, (value, transaction) => value + int.parse(transaction.valueShopper));
        result[0] += kammunProfit;
        result[1] += shopperProfit;
      }
    }
    return result;
  }

  getTransaction(String shopperId) async {
    setState(() {
      if (transactions != null) {
        error = false;
        transactions.clear();
      }
    });
    var tempTransactions = await ReportsServices.getTransactions(shopperId: shopperId, pageNumber: page);
    setState(() {
      loading = false;
      if (tempTransactions != null) {
        error = false;
        empty = false;
        transactions = tempTransactions;
        if (transactions.isEmpty) empty = true;
      } else {
        error = true;
      }
    });
  }

  getDailyProfit(String shopperId) async {
    MonthlyProfit result = await ReportsServices.getShopperMonthProfitService(shopperId: shopperId);
    setState(() {
      profitLoading = false;
      profit = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool newTransaction(int index) {
      if (index == 0) return true;
      return transactions[index].createdAt.toString().split(' ')[0] !=
          transactions[index - 1].createdAt.toString().split(' ')[0];
    }

    String shopperFilter;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text('كشف حساب متسوق', style: mainStyle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 40, color: ColorUtils.primaryColor),
                    onPressed: () {
                      if (selected && !empty) {
                        setState(() {
                          page++;
                          loading = true;
                        });
                        getTransaction(shopperId);
                      }
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: KSearchableDropdown(
                      hint: StringUtils.chooseShopper,
                      search: shopperFilter,
                      items: Services.shoppersNameList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            page = 1;
                            shopperFilter = value;
                            shopperName = value;
                            selected = true;
                            loading = true;
                            shopperId = Services.selectedShopperId(value);
                            profitLoading = true;
                          });
                          getTransaction(shopperId);
                          getDailyProfit(shopperId);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, size: 40, color: ColorUtils.primaryColor),
                    onPressed: () {
                      if (selected) {
                        setState(() {
                          if (page > 1) {
                            page--;
                            loading = true;
                          }
                        });
                        getTransaction(shopperId);
                      }
                    },
                  ),
                ],
              ),
              selected
                  ? profitLoading
                      ? const Loader()
                      : Wrap(
                          children: [
                            LabelRow(
                              rightSideText: 'مرابح الشهر : ',
                              leftSideText: profitLoading
                                  ? 'جار الاتصال'
                                  : profit != null
                                      ? StringUtils().oCcy.format(int.parse(profit.profit).abs()).toString()
                                      : 'error',
                              leftSideStyle: profitLoading
                                  ? paragraphStyle
                                  : profit != null
                                      ? int.parse(profit.profit).isNegative
                                          ? loseStyle
                                          : profitStyle
                                      : loseStyle,
                            ),
                            Wrap(
                              children: [
                                LabelRow(
                                  rightSideText: 'عدد الطلبات : ',
                                  leftSideText: profitLoading
                                      ? 'جار الاتصال'
                                      : profit != null
                                          ? profit.countOrderThisMonth.toString()
                                          : 'error',
                                  leftSideStyle: profitLoading
                                      ? paragraphStyle
                                      : profit != null
                                          ? profitStyle
                                          : loseStyle,
                                ),
                                const SizedBox(width: 10),
                                LabelRow(
                                  rightSideText: 'ساعات العمل : ',
                                  leftSideText: profitLoading
                                      ? 'جار الاتصال'
                                      : profit != null
                                          ? profit.workingHour.toString()
                                          : 'error',
                                  leftSideStyle: profitLoading
                                      ? paragraphStyle
                                      : profit != null
                                          ? profitStyle
                                          : loseStyle,
                                ),
                              ],
                            ),
                            LabelRow(
                              rightSideText: 'التقييم:',
                              leftSideText: profitLoading
                                  ? 'جار الاتصال'
                                  : profit != null
                                      ? profit.avgOrderRating.toString()
                                      : 'error',
                              leftSideStyle: profitLoading
                                  ? paragraphStyle
                                  : profit != null
                                      ? profitStyle
                                      : loseStyle,
                            ),
                            const SizedBox(width: 10),
                            LabelRow(
                              rightSideText: 'سرعة التوصيل:',
                              leftSideText: profitLoading
                                  ? 'جار الاتصال'
                                  : profit != null
                                      ? profit.avgDeliveryMinutes.toString()
                                      : 'error',
                              leftSideStyle: profitLoading
                                  ? paragraphStyle
                                  : profit != null
                                      ? profitStyle
                                      : loseStyle,
                            ),
                          ],
                        )
                  : Container(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: selected
                    ? error
                        ? Center(
                            child: AlertMessages(
                              text: StringUtils.errorMessage,
                              messageType: 'internetError',
                              headerText: 'حدث خطأ',
                            ),
                          )
                        : loading
                            ? const Loader()
                            : empty
                                ? const Padding(
                                    padding: EdgeInsets.all(75),
                                    child: ScreenMessage(message: 'لا يوجد حركة'),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: transactions.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Transaction(
                                        transaction: transactions[index],
                                        newTransaction: newTransaction(index),
                                        show: (date) async {
                                          int kammunProfit = transactions
                                              .where((transaction) =>
                                                  transaction.createdAt.toString().split(' ')[0] ==
                                                  date.toString().split(' ')[0])
                                              .toList()
                                              .fold(0,
                                                  (value, transaction) => value + int.parse(transaction.valueCompany));
                                          int shopperProfit = transactions
                                              .where((transaction) =>
                                                  transaction.createdAt.toString().split(' ')[0] ==
                                                  date.toString().split(' ')[0])
                                              .toList()
                                              .fold(0,
                                                  (value, transaction) => value + int.parse(transaction.valueShopper));
                                          List<int> completeProfits = await getCompleteProfits(date, shopperId);
                                          kammunProfit += completeProfits[0];
                                          shopperProfit += completeProfits[1];
                                          showMyDialog(
                                            title:
                                                'مرابح ${DateFormat('EEEE', 'ar').format(date) + ' ' + DateFormat('dd-MM-yyyy', 'en').format(date)}',
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(StringUtils.shopper, style: mainStyle),
                                                    Text(
                                                      StringUtils().oCcy.format(shopperProfit.abs()).toString(),
                                                      style: shopperProfit.isNegative ? loseStyle : profitStyle,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(StringUtils.kammun, style: mainStyle),
                                                    Text(
                                                      StringUtils().oCcy.format(kammunProfit.abs()).toString(),
                                                      style: kammunProfit.isNegative ? loseStyle : profitStyle,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            dialogButtons: [
                                              DialogButton(
                                                text: StringUtils.close,
                                                onTap: () => Navigator.of(context).pop(),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                    : const ScreenMessage(message: 'اختر متسوق'),
              ),
              KammunButton(
                width: MediaQuery.of(context).size.width,
                height: 50,
                text: StringUtils.addTransaction,
                color: ColorUtils.primaryColor,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddTransactionView(shopperName: shopperName)));
                },
              ),
              KammunButton(
                width: MediaQuery.of(context).size.width,
                height: 50,
                text: 'المستحقات المالية',
                color: ColorUtils.primaryColor,
                onTap: () {
                  if (selected) {
                    ReportsServices.financialDues(context: context, shopperId: shopperId);
                  } else {
                    Toast.show('يرجى اختيار متسوق', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
