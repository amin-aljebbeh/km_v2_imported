import 'package:intl/intl.dart' as intl;
import 'package:kammun_app/features/transactions/domain/entities/transaction_request_entity.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';

class TransactionRequestWidget extends StatelessWidget {
  const TransactionRequestWidget({Key key, this.transactionRequestEntity, this.ctx}) : super(key: key);
  final TransactionRequestEntity transactionRequestEntity;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: requestStatusColors[transactionRequestEntity.statusId - 1], width: 5),
              borderRadius: const BorderRadius.all(Radius.circular(13))),
          child: KCard(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                StringUtils().oCcy.format(transactionRequestEntity.value) +
                                    ' ' +
                                    state.generalInformationState.companyInformation.currency,
                                style: informationStyle),
                            Text(transactionRequestEntity.requestStatus.slug,
                                style: paragraphStyle.copyWith(
                                    color: requestStatusColors[transactionRequestEntity.statusId - 1])),
                          ],
                        ),
                      ),
                      Text(transactionRequestEntity.category.name, style: informationStyle),
                      LabelRow(
                          rightSideText: 'الوصف: ',
                          leftSideText: transactionRequestEntity.description,
                          leftSideStyle: informationStyle),
                      if (transactionRequestEntity.rejectReason != null)
                        LabelRow(
                            rightSideText: 'سبب الرفض: ',
                            leftSideText: transactionRequestEntity.rejectReason,
                            leftSideStyle: informationStyle),
                      if (transactionRequestEntity.creator != null)
                        LabelRow(
                            rightSideText: 'منشئ الطلب: ',
                            leftSideText: transactionRequestEntity.creator.name,
                            leftSideStyle: informationStyle),
                      if (transactionRequestEntity.actor != null)
                        LabelRow(
                            rightSideText: 'الطلب موجه إلى: ',
                            leftSideText: transactionRequestEntity.actor.name,
                            leftSideStyle: informationStyle),
                      if (transactionRequestEntity.orderId != null)
                        LabelRow(
                            rightSideText: 'رقم الطلب: ',
                            leftSideText: transactionRequestEntity.orderId.toString(),
                            leftSideStyle: informationStyle),
                      Text(intl.DateFormat('a h:mm - dd-MM-yyyy').format(transactionRequestEntity.createdAt),
                          style: informationStyle, textDirection: TextDirection.rtl),
                      if (transactionRequestEntity.statusId == 1)
                        transactionRequestEntity.creatorId == state.adminsState.admin.id
                            ? KammunButton(
                                color: Colors.red,
                                width: MediaQuery.of(context).size.width / 3,
                                text: 'حذف',
                                onTap: () {
                                  showMyDialog(
                                    title: 'حذف',
                                    context: context,
                                    text: 'هل أنت متأكد من رغبتك في حذف الطلب ؟',
                                    dialogButtons: [
                                      KammunButton(
                                          color: Colors.red,
                                          width: MediaQuery.of(context).size.width / 3,
                                          text: 'نعم',
                                          onTap: () {
                                            StoreProvider.of<AppState>(context).dispatch(DeleteTransactionRequestAction(
                                                context: ctx, requestId: transactionRequestEntity.id));
                                            Navigator.pop(context);
                                          }),
                                      KammunButton(
                                          color: primaryColor,
                                          width: MediaQuery.of(context).size.width / 3,
                                          text: 'لا',
                                          onTap: () => Navigator.pop(context))
                                    ],
                                  );
                                })
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  KammunButton(
                                      color: kmColors,
                                      width: MediaQuery.of(context).size.width / 3,
                                      text: 'قبول',
                                      onTap: () => StoreProvider.of<AppState>(context).dispatch(
                                          ChangeTransactionRequestStatusAction(
                                              context: ctx, statusId: 2, requestId: transactionRequestEntity.id))),
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
                                                      Navigator.pop(context);
                                                      StoreProvider.of<AppState>(context).dispatch(
                                                          ChangeTransactionRequestStatusAction(
                                                              statusId: 3,
                                                              context: ctx,
                                                              requestId: transactionRequestEntity.id,
                                                              rejectReason: reasonController.text));
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
                                                EntryField(
                                                    controller: reasonController, hint: 'سبب الرفض', onChange: () {})
                                              ],
                                            ));
                                      })
                                ],
                              ),
                    ],
                  ),
                )
              ],
            ),
            radius: const BorderRadius.all(Radius.circular(8)),
          ),
        );
      },
    );
  }
}
