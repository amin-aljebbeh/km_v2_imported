import '../../../../core/core_importer.dart';
import '../redux/orders_action.dart';
import 'reject_dialog_widget.dart';

class CancelOrRejectOrderWidget extends StatefulWidget {
  final int orderId;

  const CancelOrRejectOrderWidget({Key key, @required this.orderId}) : super(key: key);

  @override
  State<CancelOrRejectOrderWidget> createState() => _CancelOrRejectOrderWidgetState();
}

class _CancelOrRejectOrderWidgetState extends State<CancelOrRejectOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: KammunButton(
            onLongPress: () {
              TextEditingController commentController = TextEditingController();

              int rejectID = 1;
              if (Services.hasRole(context, operationManagerRole)) {
                List<DialogButton> decisionButton = [
                  DialogButton(
                    text: 'نعم',
                    onTap: () {
                      Navigator.of(context).pop();
                      StoreProvider.of<AppState>(context).dispatch(
                        ChangeOrderStatusAction(
                            orderId: widget.orderId,
                            statusId: 7,
                            comment: commentController.text,
                            cancelReasonId: rejectID),
                      );
                    },
                  ),
                  DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                ];
                showMyDialog(
                  context: context,
                  title: 'رفض الطلب',
                  content: RejectDialogWidget(
                    initialRejectID: rejectID,
                    commentController: commentController,
                    message: 'هل أنت متأكد انك تريد رفض الطلب ؟',
                    onRejectIDChanged: (newID) => setState(() => rejectID = newID),
                  ),
                  dialogButtons: decisionButton,
                );
              }
            },
            text: cancelOrder,
            width: MediaQuery.of(context).size.width * 0.4,
            color: Colors.red,
            onTap: () {
              TextEditingController commentController = TextEditingController();

              int cancelID = 1;
              List<DialogButton> decisionButton = [
                DialogButton(
                    text: 'نعم',
                    onTap: () {
                      Navigator.of(context).pop();
                      StoreProvider.of<AppState>(context).dispatch(ChangeOrderStatusAction(
                          orderId: widget.orderId,
                          statusId: 6,
                          cancelReasonId: cancelID,
                          comment: commentController.text));
                    }),
                DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
              ];
              showMyDialog(
                  context: context,
                  title: 'إلغاء الطلب',
                  content: RejectDialogWidget(
                    initialRejectID: cancelID,
                    commentController: commentController,
                    message: 'هل أنت متأكد انك تريد إلغاء الطلب ؟',
                    onRejectIDChanged: (newID) => setState(() => cancelID = newID),
                  ),
                  dialogButtons: decisionButton);
            },
          ),
        );
      },
    );
  }
}
