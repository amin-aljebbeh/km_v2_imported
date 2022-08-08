import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class ChooseAddressWidget extends StatelessWidget {
  const ChooseAddressWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          String address = state.addressState.addresses.isNotEmpty
              ? state.addressState.addresses[state.addressState.selectedIndex].street.length > 15
                  ? state.addressState.addresses[state.addressState.selectedIndex].street.substring(0, 15) + '...'
                  : state.addressState.addresses[state.addressState.selectedIndex].street
              : 'لم تقم بإضافة إي عنوان بعد';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: LabelRow(rightSideText: 'التوصيل إلى :', leftSideText: ' ', leftSideStyle: mainStyle),
                ),
                GestureDetector(
                  onTap: () {
                    if (state.ordersState.updatedOrderId == -1) {
                      chooseAddress(context: context, addresses: state.addressState.addresses, fromInvoice: false);
                    }
                  },
                  child: KCard(
                    radius: 6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              address,
                              style: decisionButtonStyle.copyWith(color: ColorUtils.primaryColor, fontSize: 15),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: ColorUtils.primaryColor)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
