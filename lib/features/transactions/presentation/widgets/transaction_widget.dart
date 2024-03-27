import 'package:intl/intl.dart' as intl;

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({Key key, this.transaction, this.newTransaction, this.ctx, this.adminId}) : super(key: key);
  final AdminTransactionEntity transaction;
  final bool newTransaction;
  final BuildContext ctx;
  final int adminId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            if (newTransaction)
              Column(
                children: [
                  Divider(thickness: 5, color: primaryColor, height: 5),
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        onTap: () async {/*StoreProvider.of<AppState>(context).dispatch(
                            ParticularDayProfits(context: ctx, date: transaction.createdAt, adminId: adminId));*/
                        // specificDayProfitWidget(context: context, date: intl.DateFormat('dd-MM-yyyy', 'en').format(transaction.createdAt), transactions:balance);

                        },
                        text: 'المجموع',
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                  const KTableRow(
                    children: [
                      KTableElement(text: 'actor'),
                      KTableElement(text: 'أدمن'),
                      KTableElement(text: 'كمُّون'),
                      KTableElement(text: 'النوع'),
                      KTableElement(text: 'الطلب')
                    ],
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: KTableRow(
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
                              context: context,
                              title: transaction.category.name,
                              dialogButtons: [],
                              text: transaction.description),
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
            ),
          ],
        );
      },
    );
  }
}
