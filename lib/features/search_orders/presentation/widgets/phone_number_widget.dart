import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/pages/phone_number_order.dart';

class PhoneNumberWidget extends StatelessWidget {
  final String phoneNumber;
  final String userName;
  final Function onChoose;

  const PhoneNumberWidget({Key key, this.phoneNumber, this.userName = ' ', this.onChoose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        StoreProvider.of<AppState>(context)
            .dispatch(SetSearchOrdersType(searchOrdersType: SearchOrdersTypes.phoneNumber));
        onChoose();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PhoneNumberOrdersView(phoneNumber: phoneNumber)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1, color: kmColors),
          LabelRow(rightSideText: phoneNumberString, leftSideText: phoneNumber, leftSideStyle: informationStyle),
          LabelRow(rightSideText: nameString + ' ', leftSideText: userName, leftSideStyle: informationStyle),
          Divider(thickness: 1, color: kmColors),
        ],
      ),
    );
  }
}
