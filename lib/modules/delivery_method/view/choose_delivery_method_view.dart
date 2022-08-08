import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kammun_app/modules/delivery_method/redux/delivery_method_action.dart';
import 'package:kammun_app/core/core_importer.dart';
import '../../invoice/redux/invoice_action.dart';

class ChooseAddressView extends StatelessWidget {
  final List<DeliveryMethodData> deliveryMethods;

  const ChooseAddressView({Key key, this.deliveryMethods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(child: Text('طريقة التوصيل', style: informationStyle)),
            Expanded(
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: deliveryMethods.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChooseInvoiceDetails(
                    title: deliveryMethods[index].name,
                    info: deliveryMethods[index].pivot.message,
                    onChoose: () {
                      StoreProvider.of<AppState>(context).dispatch(StartLoading());
                      StoreProvider.of<AppState>(context).dispatch(SelectDeliveryMethod(selectedDeliveryMethod: index));

                      CheckInvoiceModel invoiceModel =
                          state.invoiceState.invoice.copyWith(deliveryMethodId: deliveryMethods[index].id);
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

chooseDeliveryMethod({List<DeliveryMethodData> deliveryMethods, BuildContext context}) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.5,
      child: ChooseAddressView(deliveryMethods: deliveryMethods),
    ),
  );
}
