import 'package:flutter/material.dart';
import 'package:kammun_app/modules/address/redux/address_action.dart';
import '../../../core/core_importer.dart';

class AddressWidget extends StatelessWidget {
  final int index;

  const AddressWidget({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        AddressModel address = state.addressState.addresses[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              KCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.supportedCityName,
                              style: decisionButtonStyle.copyWith(color: Colors.black),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: address.street, style: disableStyle),
                                  TextSpan(text: ' ' + address.building, style: disableStyle),
                                  TextSpan(text: ' طابق ' + address.floor, style: disableStyle),
                                  TextSpan(text: ' المدخل ' + address.entrance, style: disableStyle),
                                  TextSpan(text: ' ' + address.description, style: disableStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/map.png'),
                    ],
                  ),
                ),
                radius: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Wrap(
                  spacing: MediaQuery.of(context).size.width * 0.10,
                  runSpacing: MediaQuery.of(context).size.width * 0.05,
                  children: [
                    KButton(
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: ColorUtils.primaryColor,
                        text: 'تعديل العنوان',
                        onTap: () {
                          StoreProvider.of<AppState>(context).dispatch(EditAddress(selectedAddress: index));
                          StoreProvider.of<AppState>(context).dispatch(Pop());
                          StoreProvider.of<AppState>(context).dispatch(Push(routeName: AddAddressView.routeName));
                        }),
                    KButton(
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.red[900],
                        text: 'حذف العنوان',
                        onTap: () {
                          StoreProvider.of<AppState>(context).dispatch(RemoveAddress(addressId: address.id.toString()));
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const KDivider(),
            ],
          ),
        );
      },
    );
  }
}
