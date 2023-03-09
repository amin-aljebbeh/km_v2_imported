import 'package:intl/intl.dart' as intl;

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({Key key, this.transactionEntity, this.newTransaction, this.show}) : super(key: key);
  final AdminTransactionEntity transactionEntity;
  final bool newTransaction;
  final Function(DateTime) show;

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
                      Divider(thickness: 5, color: primaryColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            intl.DateFormat('EEEE', 'ar').format(transactionEntity.createdAt) +
                                ' ' +
                                intl.DateFormat('dd-MM-yyyy', 'en').format(transactionEntity.createdAt),
                            style: disableStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: KammunButton(
                              color: primaryColor,
                              onTap: () => show(transactionEntity.createdAt),
                              text: 'المجموع',
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                        ],
                      ),
                      KTableRow(
                        children: [
                          KTableElement(text: shopper),
                          KTableElement(text: kammun),
                          const KTableElement(text: 'النوع'),
                          const KTableElement(text: 'الطلب'),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : Container(),
            Stack(
              children: [
                KTableRow(
                  children: [
                    KTableElement(
                      text: StringUtils().oCcy.format(transactionEntity.shopperValue.abs()),
                      style: transactionEntity.shopperValue >= 0 ? lightProfitStyle : lightLoseStyle,
                    ),
                    KTableElement(
                      text: StringUtils().oCcy.format(transactionEntity.companyValue.abs()),
                      style: transactionEntity.companyValue >= 0 ? lightProfitStyle : lightLoseStyle,
                    ),
                    Stack(
                      children: [
                        KTableElement(
                          text: state.transactionsState.categories
                              .firstWhere((category) => category.id == transactionEntity.transactionCategoryId)
                              .name,
                        ),
                        if (transactionEntity.description != null)
                          IconButton(
                            icon: Icon(Icons.device_unknown, color: primaryColor),
                            onPressed: () =>
                                showMyDialog(context: context, title: 'الوصف', text: transactionEntity.description),
                            padding: const EdgeInsets.only(top: 25, right: 15),
                          ),
                      ],
                    ),
                    KTableElement(
                      text: transactionEntity.orderId != null ? transactionEntity.orderId.toString() : 'null',
                      style: mainStyle.copyWith(color: Colors.purple),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
