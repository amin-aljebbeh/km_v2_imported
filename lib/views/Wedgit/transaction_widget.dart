import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/views/Wedgit/k_table_row.dart';
import 'package:kammun_app/views/Wedgit/k_table_element.dart';
import 'package:kammun_app/views/reports/models/transaction_model.dart';
import 'package:kammun_app/utils/new_utils_importer.dart';
import 'package:intl/intl.dart';

class Transaction extends StatelessWidget {
  final TransactionModel transaction;
  final bool newTransaction;

  const Transaction({
    Key key,
    @required this.transaction,
    @required this.newTransaction,
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
                      DateFormat('EEEE dd-MM-yyyy').format(transaction.date),
                      style: disableStyle,
                    ),
                    KTableRow(
                      children: [
                        // KTableElement(text: 'الوقت'),
                        KTableElement(text: 'متسوق'),
                        KTableElement(text: 'كمُّون'),
                        KTableElement(text: 'النوع'),
                        KTableElement(text: 'الطلب'),
                        KTableElement(text: 'المناقلة'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : Container(),
          KTableRow(
            children: [
              // KTableElement(
              //   text: DateFormat('h:mm a').format(transaction.date),
              //   style: mainStyle,
              // ),
              KTableElement(
                text: StringUtils()
                    .oCcy
                    .format(transaction.shopperValue.abs())
                    .toString(),
                style: transaction.shopperValue >= 0
                    ? mainStyle.copyWith(color: Colors.green)
                    : mainStyle.copyWith(color: Colors.red),
              ),
              KTableElement(
                text: StringUtils()
                    .oCcy
                    .format(transaction.kammunValue.abs())
                    .toString(),
                style: transaction.kammunValue >= 0
                    ? mainStyle.copyWith(color: Colors.green)
                    : mainStyle.copyWith(color: Colors.red),
              ),
              KTableElement(text: transaction.type),
              KTableElement(
                text: transaction.orderId != null
                    ? transaction.orderId.toString().length >= 3
                        ? "#${transaction.orderId.toString().substring(2, transaction.orderId.toString().length)}"
                        : '#${transaction.orderId.toString()}'
                    : 'null',
                style: mainStyle.copyWith(
                  color: Colors.purple,
                ),
              ),
              KTableElement(
                text: transaction.transactionId.toString().length >= 3
                    ? "#${transaction.transactionId.toString().substring(2, transaction.transactionId.toString().length)}"
                    : '#${transaction.transactionId.toString()}',
                style: mainStyle,
              ),
            ],
          ),
          transaction.description != null
              ? KTableRow(
                  children: [
                    KTableElement(text: transaction.description),
                  ],
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
