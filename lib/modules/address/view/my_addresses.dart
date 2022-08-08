import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../../supported_city/redux/supported_city_action.dart';
import '../redux/address_action.dart';

class MyAddresses extends StatefulWidget {
  static const String routeName = '/MyAddresses';

  const MyAddresses({Key key}) : super(key: key);

  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            appBar: NormalAppBar(title: StringUtils.addressTitle),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 15, bottom: 8, left: 15),
                  child: KOutlinedButton(
                    height: 50,
                    color: ColorUtils.kmColors,
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(EditAddress(selectedAddress: -1));
                      StoreProvider.of<AppState>(context).dispatch(StartLoading());
                      StoreProvider.of<AppState>(context).dispatch(GetSupportedCities());
                    },
                    width: MediaQuery.of(context).size.width,
                    text: '+' + StringUtils.addNewAddress,
                  ),
                ),
                state.addressState.addresses.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8, bottom: 11, left: 8),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            itemCount: state.addressState.addresses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AddressWidget(index: index);
                            },
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 175),
                        child: Center(child: Text('لم تقم بإضافة أي عنوان بعد', style: paragraphStyle)),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
