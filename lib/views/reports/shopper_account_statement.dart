import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/reports/add_transaction_view.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';

import '../../Services.dart';
import 'models/transaction_model.dart';

class ShopperAccountStatement extends StatefulWidget {
  @override
  _ShopperAccountStatementState createState() => _ShopperAccountStatementState();
}

class _ShopperAccountStatementState extends State<ShopperAccountStatement> {
  bool selected;
  bool error;
  bool profitError;
  bool empty;
  bool loading;
  bool profitLoading;
  List<TransactionModel> transactions = List<TransactionModel>();
  String shopperName;
  String shopperId;
  int page;
  String profit;

  @override
  void initState() {
    page = 1;
    error = false;
    profitError = false;
    empty = true;
    selected = false;
    loading = false;
    profitLoading = false;
    if (Services.isShopper()) {
      setState(() {
        profitLoading = true;
      });
      getDailyProfit(Services.shopper.id.toString());
      getTransaction(Services.shopper.id.toString());
    }
    super.initState();
  }

  getTransaction(String shopperId) async {
    setState(() {
      if (Services.isShopper()) selected = true;
      if (transactions != null) {
        error = false;
        transactions.clear();
      }
    });
    var tempTransactions;
    if (Services.isShopper())
      tempTransactions = await ReportsServices.getShopperTransaction();
    else
      tempTransactions = await ReportsServices.getTransactions(shopperId: shopperId, pageNumber: page);
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
    String result = await ReportsServices.getShopperDailyProfit(shopperId: shopperId);
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
        title: Text(
          'كشف حساب متسوق',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: ListView(
            children: [
              Column(
                children: [
                  Services.isAccounting()
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 40,
                                color: ColorUtils.primaryColor,
                              ),
                              onPressed: () {
                                if (selected && !empty) {
                                  setState(() {
                                    page++;
                                    loading = true;
                                  });
                                  getTransaction(
                                      Services.isAccounting() ? shopperId : Services.shopper.id.toString());
                                }
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: KSearchableDropdown(
                                hint: StringUtils.chooseShopper,
                                search: shopperFilter,
                                items: Services.shoppersNameList(),
                                onChanged: (value) {
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
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                size: 40,
                                color: ColorUtils.primaryColor,
                              ),
                              onPressed: () {
                                if (selected) {
                                  setState(() {
                                    if (page > 1) {
                                      page--;
                                      loading = true;
                                    }
                                  });
                                  getTransaction(
                                      Services.isAccounting() ? shopperId : Services.shopper.id.toString());
                                }
                              },
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: LabelRow(
                            rightSideText: 'مرابح اليوم : ',
                            leftSideText: profit != null
                                ? StringUtils().oCcy.format(int.parse(profit).abs()).toString()
                                : 'error',
                            leftSideStyle: profit != null
                                ? int.parse(profit).isNegative
                                    ? loseStyle
                                    : profitStyle
                                : loseStyle,
                          ),
                        ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.043,
                    child: selected
                        ? profitLoading
                            ? Loader()
                            : Services.isAccounting()
                                ? LabelRow(
                                    rightSideText: 'مرابح اليوم : ',
                                    leftSideText: profit != null
                                        ? StringUtils().oCcy.format(int.parse(profit).abs()).toString()
                                        : 'error',
                                    leftSideStyle: profit != null
                                        ? int.parse(profit).isNegative
                                            ? loseStyle
                                            : profitStyle
                                        : loseStyle,
                                  )
                                : Container()
                        : Container(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.61,
                    child: selected
                        ? error
                            ? Center(
                                child: AlertMessages(
                                  text: StringUtils.errorMessage,
                                  messageType: "internetError",
                                  headerText: "حدث خطأ",
                                ),
                              )
                            : loading
                                ? Loader()
                                : empty
                                    ? Padding(
                                        padding: const EdgeInsets.all(75),
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
                                          );
                                        },
                                      )
                        : ScreenMessage(
                            message: 'اختر متسوق',
                          ),
                  ),
                  Services.isAccounting()
                      ? KammunButton(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          text: 'إضافة مناقلة',
                          color: ColorUtils.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new AddTransactionView(
                                  shopperName: shopperName,
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: 50,
                        ),
                ],
              ),
              KammunButton(
                width: MediaQuery.of(context).size.width,
                height: 50,
                text: 'المستحقات المالية',
                color: ColorUtils.primaryColor,
                onTap: () {
                  if (Services.isShopper()) {
                    shopperId = Services.shopper.id.toString();
                    selected = true;
                  }
                  if (selected) {
                    ReportsServices.financialDues(context: context, shopperId: shopperId);
                  } else {
                    Toast.show(
                      "يرجى اختيار متسوق",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER,
                    );
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
