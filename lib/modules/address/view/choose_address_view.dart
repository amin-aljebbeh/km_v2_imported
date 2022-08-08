import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kammun_app/modules/delivery_method/redux/delivery_method_action.dart';
import 'package:kammun_app/modules/invoice/redux/invoice_action.dart';
import 'package:kammun_app/modules/supported_city/redux/supported_city_action.dart';
import '../../../core/core_importer.dart';
import '../redux/address_action.dart';

class ChooseAddressView extends StatelessWidget {
  final List<AddressModel> addresses;
  final bool fromInvoice;
  const ChooseAddressView({Key key, this.addresses, this.fromInvoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(Pop());
                StoreProvider.of<AppState>(context).dispatch(StartLoading());
                StoreProvider.of<AppState>(context).dispatch(GetSupportedCities());
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 0, right: 25),
                child:
                    Text('+ ' + StringUtils.addNewAddress, style: paragraphStyle.copyWith(color: ColorUtils.kmColors)),
              ),
            ),
            addresses.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: addresses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChooseInvoiceDetails(
                          title: addresses[index].supportedCityName,
                          info: addresses[index].street,
                          icon: Icons.location_on,
                          onChoose: () {
                            StoreProvider.of<AppState>(context).dispatch(StartLoading());
                            StoreProvider.of<AppState>(context).dispatch(SelectAddress(
                                selectedAddress: index,
                                firebaseToken: state.startupState.startModel.user.firebaseToken));
                            StoreProvider.of<AppState>(context).dispatch(Pop());
                            StoreProvider.of<AppState>(context)
                                .dispatch(GetDeliveryMethods(addressId: addresses[index].id));
                            StoreProvider.of<AppState>(context)
                                .dispatch(SelectDeliveryMethod(selectedDeliveryMethod: 0));

                            if (!fromInvoice) {
                              StoreProvider.of<AppState>(context).dispatch(UpdateUserSupportedCity(
                                  supportedCityId: addresses[index].supportedCityId, initial: false));
                            } else {
                              CheckInvoiceModel invoiceModel =
                                  state.invoiceState.invoice.copyWith(addressId: addresses[index].id);
                              StoreProvider.of<AppState>(context)
                                  .dispatch(CheckInvoice(goToInvoice: !fromInvoice, invoice: invoiceModel));
                            }
                          },
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 175),
                    child: Center(child: Text('لم تقم بإضافة أي عنوان بعد', style: paragraphStyle)),
                  ),
          ],
        );
      },
    );
  }
}

chooseAddress({List<AddressModel> addresses, BuildContext context, bool fromInvoice = true}) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.5,
      child: ChooseAddressView(addresses: addresses, fromInvoice: fromInvoice),
    ),
  );
}
