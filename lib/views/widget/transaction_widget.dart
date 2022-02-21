import 'package:flutter/material.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/reports/models/transaction_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:intl/intl.dart';

class Transaction extends StatelessWidget {
  final TransactionModel transaction;
  final bool newTransaction;
  final Function(DateTime) show;

  const Transaction({
    Key key,
    @required this.transaction,
    @required this.newTransaction,
    this.show,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE', 'ar').format(transaction.createdAt) +
                              ' ' +
                              DateFormat('dd-MM-yyyy', 'en').format(transaction.createdAt),
                          style: disableStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: KammunButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              show(transaction.createdAt);
                            },
                            text: 'المجموع',
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                        ),
                      ],
                    ),
                    KTableRow(
                      children: [
                        KTableElement(text: StringUtils.shopper),
                        KTableElement(text: StringUtils.kammun),
                        KTableElement(text: 'النوع'),
                        KTableElement(text: 'الطلب'),
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
                    text: StringUtils().oCcy.format(int.parse(transaction.valueShopper).abs()).toString(),
                    style: int.parse(transaction.valueShopper) >= 0
                        ? mainStyle.copyWith(color: Colors.green)
                        : mainStyle.copyWith(color: Colors.red),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(int.parse(transaction.valueCompany).abs()).toString(),
                    style: int.parse(transaction.valueCompany) >= 0
                        ? mainStyle.copyWith(color: Colors.green)
                        : mainStyle.copyWith(color: Colors.red),
                  ),
                  Stack(
                    children: [
                      KTableElement(
                        text: StringUtils.transactionTypesMap[LoadingScreenServices.transactionTypes
                            .firstWhere((type) => type.id == int.parse(transaction.transactionTypeId))
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
                            ? "#${transaction.orderId.toString().substring(transaction.orderId.toString().length - 3, transaction.orderId.toString().length)}"
                            : '#${transaction.orderId.toString()}'
                        : 'null',
                    style: mainStyle.copyWith(
                      color: Colors.purple,
                    ),
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
