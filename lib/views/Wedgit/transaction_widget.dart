import 'package:flutter/material.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/reports/models/transaction_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
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
                    Divider(
                      thickness: 5,
                      color: ColorUtils.primaryColor,
                    ),
                    Text(
                      DateFormat('EEEE', 'ar').format(transaction.createdAt) +
                          ' ' +
                          DateFormat('dd-MM-yyyy', 'en')
                              .format(transaction.createdAt),
                      style: disableStyle,
                    ),
                    KTableRow(
                      children: [
                        KTableElement(text: StringUtils.shopper),
                        KTableElement(text: StringUtils.kammun),
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
          Stack(
            children: [
              KTableRow(
                children: [
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(transaction.valueShopper.abs())
                        .toString(),
                    style: transaction.valueShopper >= 0
                        ? mainStyle.copyWith(color: Colors.green)
                        : mainStyle.copyWith(color: Colors.red),
                  ),
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(transaction.valueCompany.abs())
                        .toString(),
                    style: transaction.valueCompany >= 0
                        ? mainStyle.copyWith(color: Colors.green)
                        : mainStyle.copyWith(color: Colors.red),
                  ),
                  Stack(
                    children: [
                      KTableElement(
                        text: StringUtils.transactionTypesMap[
                            LoadingScreenServices.transactionTypes
                                .firstWhere((type) =>
                                    type.id == transaction.transactionTypeId)
                                .slug],
                      ),
                      transaction.description != null
                          ? IconButton(
                              icon: Icon(
                                Icons.device_unknown,
                                color: ColorUtils.primaryColor,
                              ),
                              onPressed: () {
                                showMyDialog(
                                  title: 'الوصف',
                                  context: context,
                                  text: transaction.description,
                                );
                              },
                              padding: EdgeInsets.only(top: 25, right: 15),
                            )
                          : Container(),
                    ],
                  ),
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
                    text: transaction.id.toString().length >= 3
                        ? "#${transaction.id.toString().substring(2, transaction.id.toString().length)}"
                        : '#${transaction.id.toString()}',
                    style: mainStyle,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
