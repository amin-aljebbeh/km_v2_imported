import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kammun_app/modules/invoice/redux/invoice_action.dart';
import 'package:kammun_app/modules/payment/redux/payment_action.dart';
import '../../../core/core_importer.dart';
import '../models/payment_method_model.dart';

class ChoosePaymentView extends StatelessWidget {
  final List<PaymentMethodModel> paymentMethods;
  const ChoosePaymentView({Key key, this.paymentMethods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [Icons.payment, Icons.payment, Icons.payment, Icons.payment, Icons.payment];
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(child: Text('طريقة الدفع', style: informationStyle)),
            Expanded(
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: paymentMethods.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChooseInvoiceDetails(
                    title: paymentMethods[index].name,
                    icon: icons[index],
                    info: paymentMethods[index].description,
                    onChoose: () {
                      StoreProvider.of<AppState>(context).dispatch(StartLoading());
                      StoreProvider.of<AppState>(context).dispatch(SelectPaymentMethod(selectedPaymentMethod: index));
                      CheckInvoiceModel invoiceModel =
                          state.invoiceState.invoice.copyWith(paymentMethodId: paymentMethods[index].id);
                      StoreProvider.of<AppState>(context)
                          .dispatch(CheckInvoice(goToInvoice: false, invoice: invoiceModel));

                      StoreProvider.of<AppState>(context).dispatch(Pop());
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

choosePaymentMethod({List<PaymentMethodModel> paymentMethods, BuildContext context}) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.5,
        child: ChoosePaymentView(paymentMethods: paymentMethods)),
  );
}
