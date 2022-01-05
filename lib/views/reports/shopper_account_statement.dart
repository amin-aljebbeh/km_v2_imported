import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';

import '../../Services.dart';
import 'models/transaction_model.dart';

class ShopperAccountStatement extends StatefulWidget {
  @override
  _ShopperAccountStatementState createState() =>
      _ShopperAccountStatementState();
}

class _ShopperAccountStatementState extends State<ShopperAccountStatement> {
  bool selected;
  bool error;
  bool empty;
  String kammunDues;
  String shopperDues;
  List<TransactionModel> transactions = List<TransactionModel>();

  @override
  void initState() {
    if (Services.isShopper()) {
      //TODO: request api instead
      kammunDues = '3550';
      shopperDues = '3550';
    } else {
      kammunDues = '0';
      shopperDues = '0';
    }
    error = false;
    empty = true;
    selected = false;
    super.initState();
  }

  getTransaction(String shopperId) async {
    setState(() {
      if (transactions != null) transactions.clear();
    });
    var tempTransactions =
        await ReportsServices.getShopperTransactions(shopperId: shopperId);
    setState(() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Services.isOperationManager()
                  ? KSearchableDropdown(
                      hint: StringUtils.chooseShopper,
                      search: shopperFilter,
                      items: Services.shoppersNameList(),
                      onChanged: (value) async {
                        shopperFilter = value;
                        setState(
                          () {
                            selected = true;
                            shopperDues = '2000';
                            kammunDues = '3150';
                          },
                        );
                        String shopperId = Services.selectedShopperId(value);

                        await getTransaction(shopperId);
                        //TODO: request api and assign values to [kammunDues,shopperDues]
                      },
                    )
                  : SizedBox(
                      height: 025,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    StringUtils()
                        .oCcy
                        .format(int.parse(shopperDues))
                        .toString(),
                    style: profitStyle,
                  ),
                  Services.isOperationManager()
                      ? Text(
                          StringUtils()
                              .oCcy
                              .format(int.parse(kammunDues))
                              .toString(),
                          style: profitStyle.copyWith(
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
              Services.isOperationManager() && selected
                  ? !error
                      ? empty
                          ? Padding(
                              padding: const EdgeInsets.all(75),
                              child: ScreenMessage(
                                message: 'لا يوجد حركة',
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: transactions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Transaction(
                                    transaction: transactions[index],
                                    newTransaction: newTransaction(index),
                                  );
                                },
                              ),
                            )
                      : AlertMessages(
                          text: "حدث خطأ اثناء محاولة جلب البيانات",
                          messageType: "internetError",
                          headerText: "حدث خطأ",
                        )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
