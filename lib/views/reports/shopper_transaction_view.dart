import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import '../../Services.dart';
import 'models/transaction_model.dart';

class ShopperTransactionView extends StatefulWidget {
  const ShopperTransactionView({Key key}) : super(key: key);

  @override
  _ShopperTransactionViewState createState() => _ShopperTransactionViewState();
}

class _ShopperTransactionViewState extends State<ShopperTransactionView> {
  bool error;
  bool empty;
  bool loading;
  bool profitLoading;
  List<TransactionModel> transactions = [];
  String profit;

  @override
  void initState() {
    error = false;
    empty = true;
    loading = false;
    setState(() {
      profitLoading = true;
    });
    getMonthlyProfit(Services.shopper.id.toString());
    getTransaction(Services.shopper.id.toString());
    super.initState();
  }

  getTransaction(String shopperId) async {
    setState(() {
      if (transactions != null) {
        error = false;
        transactions.clear();
      }
    });
    var tempTransactions = await ReportsServices.getShopperTransaction();
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

  getMonthlyProfit(String shopperId) async {
    String result = await ReportsServices.getShopperMonthProfitService(shopperId: shopperId);
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

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'كشف حساب متسوق',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: LabelRow(
                      rightSideText: 'مرابح الشهر : ',
                      leftSideText: profitLoading
                          ? 'جار الاتصال'
                          : profit != null
                              ? StringUtils().oCcy.format(int.parse(profit).abs()).toString()
                              : 'error',
                      leftSideStyle: profitLoading
                          ? paragraphStyle
                          : profit != null
                              ? int.parse(profit).isNegative
                                  ? loseStyle
                                  : profitStyle
                              : loseStyle,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: error
                        ? Center(
                            child: AlertMessages(
                              text: StringUtils.errorMessage,
                              messageType: "internetError",
                              headerText: "حدث خطأ",
                            ),
                          )
                        : loading
                            ? const Loader()
                            : empty
                                ? const Padding(
                                    padding: EdgeInsets.all(75),
                                    child: ScreenMessage(
                                      message: 'لا يوجد حركة',
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: transactions.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Transaction(
                                        transaction: transactions[index],
                                        newTransaction: newTransaction(index),
                                        show: (date) {
                                          int kammunProfit = transactions
                                              .where((transaction) =>
                                                  transaction.createdAt.toString().split(' ')[0] ==
                                                  date.toString().split(' ')[0])
                                              .toList()
                                              .fold(
                                                  0,
                                                  (value, transaction) =>
                                                      value + int.parse(transaction.valueCompany));

                                          int shopperProfit = transactions
                                              .where((transaction) =>
                                                  transaction.createdAt.toString().split(' ')[0] ==
                                                  date.toString().split(' ')[0])
                                              .toList()
                                              .fold(
                                                  0,
                                                  (value, transaction) =>
                                                      value + int.parse(transaction.valueShopper));
                                          showMyDialog(
                                            title:
                                                'مرابح ${DateFormat('EEEE', 'ar').format(date) + ' ' + DateFormat('dd-MM-yyyy', 'en').format(date)}',
                                            context: context,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      StringUtils.shopper,
                                                      style: mainStyle,
                                                    ),
                                                    Text(
                                                      StringUtils().oCcy.format(shopperProfit.abs()).toString(),
                                                      style: shopperProfit.isNegative ? loseStyle : profitStyle,
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
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
              KammunButton(
                width: MediaQuery.of(context).size.width,
                height: 50,
                text: 'المستحقات المالية',
                color: ColorUtils.primaryColor,
                onTap: () {
                  ReportsServices.financialDues(context: context, shopperId: Services.shopper.id.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
