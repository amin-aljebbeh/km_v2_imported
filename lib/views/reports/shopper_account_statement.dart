import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/k_searchable_dropdown.dart';
import 'package:kammun_app/views/Wedgit/transaction_widget.dart';

import '../../Services.dart';
import 'models/transaction_model.dart';

class ShopperAccountStatement extends StatefulWidget {
  @override
  _ShopperAccountStatementState createState() =>
      _ShopperAccountStatementState();
}

class _ShopperAccountStatementState extends State<ShopperAccountStatement> {
  String shopperFilter;
  bool selected;
  String kammunDues;
  String shopperDues;
  DateTime dateTime1 = DateTime.parse("2021-12-29 09:42:33");
  DateTime dateTime2 = DateTime.parse("2021-12-30 09:42:33");

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

    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> transactions = [
      TransactionModel(
        1,
        12124,
        3,
        'تسوق',
        -500,
        1000,
        null,
        dateTime1,
      ),
      TransactionModel(
        2,
        12124,
        3,
        'طريقة توصيل',
        -500,
        0,
        null,
        dateTime1,
      ),
      TransactionModel(
        3,
        12124,
        3,
        'توصيل',
        -300,
        700,
        null,
        dateTime1,
      ),
      TransactionModel(
        4,
        null,
        3,
        'إقراض',
        -50000,
        0,
        'إيداع في الحساب',
        dateTime1,
      ),
      TransactionModel(
        5,
        12124,
        3,
        'حسم',
        -100,
        -100,
        'انكسرت بيضة عالطريق',
        dateTime1,
      ),
      TransactionModel(
        6,
        12124,
        3,
        'تعديل طلب',
        200,
        -200,
        null,
        dateTime1,
      ),
      TransactionModel(
        7,
        null,
        3,
        'تسديد',
        53700,
        0,
        null,
        dateTime2,
      ),
      TransactionModel(
        8,
        12125,
        3,
        'تسوق',
        -600,
        1100,
        null,
        dateTime2,
      ),
      TransactionModel(
        9,
        12125,
        3,
        'طريقة التوصيل',
        500,
        0,
        null,
        dateTime2,
      ),
      TransactionModel(
        10,
        12126,
        3,
        'حسم',
        -200,
        -200,
        'تأخير الطلب',
        dateTime2,
      ),
    ];
    bool newTransaction(int index) {
      if (index == 0) return true;
      return transactions[index].date != transactions[index - 1].date;
    }

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
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 10, right: 0, bottom: 10),
                      child: KSearchableDropdown(
                        hint: StringUtils.chooseShopper,
                        search: shopperFilter,
                        items: Services.shoppersNameList(),
                        onChanged: (value) {
                          //TODO: request api and assign values to [kammunDues,shopperDues]
                          setState(
                            () {
                              shopperFilter = value;
                              selected = true;
                              shopperDues = '2000';
                              kammunDues = '3150';
                            },
                          );
                        },
                      ),
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
                  ? Container(
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
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
