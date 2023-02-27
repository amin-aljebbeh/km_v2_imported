import 'package:kammun_app/features/transactions/domain/entities/transaction_request_entity.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';

class TransactionRequestWidget extends StatelessWidget {
  const TransactionRequestWidget({Key key, this.transactionRequestEntity}) : super(key: key);
  final TransactionRequestEntity transactionRequestEntity;

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KammunButton(
                        color: kmColors,
                        width: MediaQuery.of(context).size.width / 3,
                        text: 'قبول',
                        onTap: () => StoreProvider.of<AppState>(context).dispatch(
                            UpdateTransactionRequestAction(transactionRequestEntity: transactionRequestEntity))),
                    KammunButton(
                        color: Colors.red,
                        width: MediaQuery.of(context).size.width / 3,
                        text: 'رفض',
                        onTap: () {
                          TextEditingController reasonController = TextEditingController();
                          showMyDialog(
                              title: 'رفض',
                              context: context,
                              dialogButtons: [
                                KammunButton(
                                    color: Colors.red,
                                    width: MediaQuery.of(context).size.width / 3,
                                    text: 'رفض',
                                    onTap: () {
                                      if (reasonController.text.isNotEmpty) {
                                        StoreProvider.of<AppState>(context).dispatch(UpdateTransactionRequestAction(
                                            transactionRequestEntity: transactionRequestEntity));
                                      }
                                    })
                              ],
                              content: Column(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'هل أنت متأكد من رغبتك في رفض الطلب؟\n',
                                        style: dialogStyle.copyWith(color: Colors.black)),
                                    TextSpan(
                                        text: 'الرجاء كتابة سبب الرفض',
                                        style: dialogStyle.copyWith(color: Colors.black))
                                  ])),
                                  EntryField(controller: reasonController, hint: 'سبب الرفض')
                                ],
                              ));
                        })
                  ],
                ))
          ],
        ),
      ),
      radius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
