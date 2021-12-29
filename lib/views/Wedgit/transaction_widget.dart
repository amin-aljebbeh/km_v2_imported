import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/views/Wedgit/k_table_row.dart';
import 'package:kammun_app/views/Wedgit/k_table_element.dart';
import 'package:kammun_app/views/reports/models/transaction_model.dart';

class Transaction extends StatelessWidget {
  final TransactionModel transaction;
  final bool newTransaction;
  final bool des;

  const Transaction({
    Key key,
    this.transaction,
    this.newTransaction,
    this.des,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          newTransaction
              ? Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '2021-11-17T05:10:19.000000Z',
                      style: disableStyle,
                    ),
                  ],
                )
              : Container(),
          KTableRow(
            children: [
              KTableElement(text: 'متسوق'),
              KTableElement(text: 'كمُّون'),
              KTableElement(text: 'النوع'),
              KTableElement(text: 'الطلب'),
              KTableElement(text: 'المناقلة'),
            ],
          ),
          des
              ? KTableRow(
                  children: [
                    KTableElement(text: 'الوصف: شرح سبب الخصم.'),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
