import 'package:intl/intl.dart' as intl;
import 'package:kammun_app/features/transactions/presentation/widgets/specific_day_profit_widget.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({Key key, this.transaction, this.newTransaction}) : super(key: key);
  final AdminTransactionEntity transaction;
  final bool newTransaction;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            newTransaction
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            intl.DateFormat('EEEE', 'ar').format(transaction.createdAt) +
                                ' ' +
                                intl.DateFormat('dd-MM-yyyy', 'en').format(transaction.createdAt),
                            style: disableStyle,
                          ),
                          KammunButton(
                            color: primaryColor,
                            padding: 0,
                            onTap: () => specificDayProfitWidget(context: context, date: transaction.createdAt),
                            text: 'المجموع',
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                        ],
                      ),
                      KTableRow(
                        children: [
                          const KTableElement(text: 'actor'),
                          const KTableElement(text: 'أدمن'),
                          KTableElement(text: kammun),
                          const KTableElement(text: 'النوع'),
                          const KTableElement(text: 'الطلب'),
                        ],
                      ),
                    ],
                  )
                : Container(),
            Stack(
              children: [
                KTableRow(
                  children: [
                    KTableElement(text: transaction.actor != null ? transaction.actor.name : '', style: mainStyle),
                    KTableElement(
                      text: StringUtils().oCcy.format(int.parse(transaction.shopperValue).abs()),
                      style: int.parse(transaction.shopperValue) >= 0 ? lightProfitStyle : lightLoseStyle,
                    ),
                    KTableElement(
                      text: StringUtils().oCcy.format(int.parse(transaction.companyValue).abs()),
                      style: int.parse(transaction.companyValue) >= 0 ? lightProfitStyle : lightLoseStyle,
                    ),
                    Stack(
                      children: [
                        KTableElement(text: transaction.category.name),
                        if (transaction.description != null)
                          IconButton(
                            icon: Icon(Icons.device_unknown, color: primaryColor),
                            onPressed: () => showMyDialog(
                                context: context, title: transaction.category.name, text: transaction.description),
                            padding: const EdgeInsets.only(top: 25, right: 15),
                          ),
                      ],
                    ),
                    KTableElement(
                      text: transaction.orderId != null ? transaction.orderId.toString() : 'null',
                      style: mainStyle.copyWith(color: Colors.purple),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
