import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';

import '../../../../core/core_importer.dart';
import '../../../coupons/presentation/redux/coupon_action.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../../users/presentation/pages/user_management_view.dart';
import '../../../users/presentation/redux/users_action.dart';
import '../../domain/entities/order_entity.dart';
import '../../orders_services.dart';

class AdminOrderInfoWidget extends StatelessWidget {
  final OrderEntity order;

  const AdminOrderInfoWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  LabelRow(
                    rightSideText: phoneNumberString,
                    leftSideText: order.user.phone,
                    leftSideStyle: paragraphStyle.copyWith(color: kmColors),
                    recognizer: TapGestureRecognizer()..onTap = () => Services.makePhoneCall(order.user.phone),
                  ),
                  if (Services.hasRole(context, operationManagerRole))
                    InkWell(
                      child: Icon(Icons.copy, color: kmColors, size: 25),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: order.user.phone));
                        Toast.show('تم نسخ الرقم', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                      },
                    ),
                  if (Services.hasRole(context, agentRole))
                    InkWell(
                      child: Icon(Icons.manage_accounts_rounded, color: kmColors, size: 25),
                      onTap: () {
                        store.dispatch(SetUser(userEntity: UserEntity(id: order.user.id, balance: order.user.balance)));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagement(order: order)));
                        store.dispatch(FirstCouponsPage());
                        store.dispatch(GetCouponsAction());
                        store.dispatch(GetUserCouponsAction(userId: order.user.id));
                      },
                    ),
                  if (Services.hasRole(context, operationManagerRole))
                    MediaIcon(
                        icon: FontAwesomeIcons.whatsapp, url: 'customer_whatsapp', mobileNumber: order.user.phone),
                  if (Services.hasRole(context, operationManagerRole))
                    InkWell(
                      child: Icon(Icons.search_rounded, color: kmColors, size: 30),
                      onTap: () {
                        if (state.searchOrdersState.searchOrdersType != SearchOrdersTypes.none) {
                          Navigator.of(context).pop();
                        }
                        store.dispatch(SetPhoneNumber(phoneNumber: order.user.phone));
                        store.dispatch(
                            SearchOrderAction(context: context, searchOrdersType: SearchOrdersTypes.phoneNumber));
                      },
                    ),
                  if (Services.hasRole(context, agentRole))
                    InkWell(
                      child: Icon(Icons.report_problem_rounded, color: kmColors, size: 30),
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (screenContext) => AddComplaintPage(orderData: order))),
                    ),
                  if (order.address.lat != -1 && order.address.lon != -1)
                    InkWell(
                        child: Icon(Icons.location_on, color: kmColors, size: 30),
                        onTap: () => openMapSheet(context: context, lat: order.address.lat, lon: order.address.lon)),
                ],
              ),
            ),
            LabelRow(
                rightSideText: address + ' : ',
                leftSideText: order.address.street +
                    ' ' +
                    order.address.building +
                    ' طابق ' +
                    order.address.floor +
                    ' ' +
                    order.address.description,
                leftSideStyle: informationStyle),
            LabelRow(
                rightSideText: city,
                leftSideText: state.generalInformationState.supportedCities
                        .where((supportedCity) => supportedCity.id == order.supportedCityId)
                        .first
                        .name +
                    '   ',
                leftSideStyle: informationStyle),
            LabelRow(rightSideText: entrance, leftSideText: order.address.entrance, leftSideStyle: informationStyle),
          ],
        );
      },
    );
  }
}
