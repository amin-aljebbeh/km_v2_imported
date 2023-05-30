import 'package:intl/intl.dart';
import 'package:kammun_app/features/coupons/presentation/redux/coupon_action.dart';
import 'package:kammun_app/features/order_details/pages/order_details_tab_view.dart';
import 'package:kammun_app/features/orders/pages/orders_view_importer.dart';
import 'package:kammun_app/features/orders/services/order_services.dart';
import 'package:kammun_app/features/orders_feature/presentation/redux/orders_action.dart';
import 'package:kammun_app/features/users/presentation/redux/users_action.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../core/core_importer.dart';
import '../../users/domain/entities/user_entity.dart';
import '../../users/presentation/pages/user_management_view.dart';

class OrdersViewCard extends StatelessWidget {
  final OrdersOriginalData order;
  final OrderTypes orderType;
  final bool pop;

  const OrdersViewCard({Key key, @required this.order, @required this.orderType, this.pop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orderStatus = 'طلبك قيد المعالجة ⌛️';
    switch (order.orderStatusId) {
      case '2':
        orderStatus = 'تم قبول الطلب ✅';
        break;
      case '3':
        orderStatus = 'تم تجهيز الطلب 😎';
        break;
      case '4':
        orderStatus = 'تم إرسال الطلب مع كابتن التوصيل';
        break;
      case '5':
        orderStatus = 'تم توصيل الطلب بنجاح';
        break;
      case '6':
        orderStatus = 'تم إلغاء الطلب من قبلكم 🚫';
        break;
      case '7':
        orderStatus = '😔 لم نستطع تأمين الطلب 😔';
        break;
      case '8':
        orderStatus = 'معلق للدفع الإلكتروني';
        break;
      case '9':
        orderStatus = 'فشل في الدفع الإلكتروني';
        break;
    }
    switch (order.underUpdate) {
      case '1':
        orderStatus = 'الطلب معلق حتى يأكد الزبون التعديل';
        break;
      case '2':
        orderStatus = 'الطلب معلق حتى تقوم بتأكيد التعديل';
        break;
    }

    Color color = order.userData.orderCount <= 3 && !order.userData.orderCount.isNegative
        ? kmColors2
        : order.deliveryMethodId == '2'
            ? Colors.red[700]
            : order.deliveryMethodId == '3'
                ? Colors.green
                : Colors.red[500];
    String shopper;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsTabView(
                  orderData: order,
                  deletedProducts: Services.hasRole(context, operationManagerRole) &&
                      order.products.where((product) => product.pivot.deletedAt != 'null').isNotEmpty,
                  subTotal: int.parse(order.total.toString().split('.')[0]) -
                      int.parse(order.supportedCityCost.toString().split('.')[0]) -
                      int.parse(order.deliveryCost.split('.')[0]),
                  orderType: orderType))),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color, width: 5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LabelRow(
                    rightSideText: bill,
                    leftSideText: StringUtils().oCcy.format(int.parse(order.cashValue.split('.')[0]).abs()) +
                        ' ' +
                        StaticVariables.companyInformation.currency,
                    leftSideStyle: int.parse(order.cashValue.split('.')[0]).isNegative
                        ? informationStyle.copyWith(color: Colors.red)
                        : informationStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.2))),
                    child: Text(
                      order.products.where((product) => product.pivot.deletedAt == 'null').length.toString(),
                      style: paragraphStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (Services.hasRole(context, operationManagerRole) &&
                      order.products.where((product) => product.pivot.deletedAt != 'null').isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(border: Border.all(color: Colors.red.withOpacity(0.2))),
                      child: Text(
                          order.products.where((product) => product.pivot.deletedAt != 'null').length.toString(),
                          style: loseStyle.copyWith(fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                  if (Services.hasRole(context, agentRole) && (order.userPriceRating != 'null'))
                    IconButton(
                      icon: Icon(Icons.star_rounded,
                          color: order.userDeliveryRating == 'null'
                              ? Colors.black
                              : int.parse(order.userDeliveryRating.split('.')[0]) < 5
                                  ? Colors.red
                                  : kmColors2,
                          size: 30),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        int rate;
                        rate = order.userDeliveryRating != 'null' ? int.parse(order.userDeliveryRating) : null;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text(ratingOrder, style: dialogStyle),
                                  scrollable: true,
                                  content: Column(
                                    children: [
                                      Text(order.userDeliveryRating.toString() + '\n' + order.userFeedback + '\n',
                                          style: dialogStyle),
                                      DropdownButton(
                                          items: [1, 2, 3, 4, 5, null]
                                              .map((rate) => DropdownMenuItem<int>(
                                                  child: Text(rate.toString(), style: dropdownItemStyle), value: rate))
                                              .toList(),
                                          value: rate,
                                          onChanged: (value) {
                                            setState(() => rate = value);
                                            StoreProvider.of<AppState>(context).dispatch(UpdateOrderRatingAction(
                                                deliveryRating: value, orderId: order.id, context: context));
                                          })
                                    ],
                                  ),
                                  actions: const [CloseWidget()],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        order.id.toString().length >= 3
                            ? '#${order.id.toString().substring(order.id.toString().length - 3, order.id.toString().length)}'
                            : '#${order.id.toString()}',
                        style: profitStyle.copyWith(color: Colors.purple),
                      ),
                      RichText(
                          text: TextSpan(
                              text: StringUtils().oCcy.format(order.shopperProfit +
                                  (order.shopper != null
                                      ? OrderServices.gasAllowance(
                                          deliveryDistance: order.deliveryDistance,
                                          context: context,
                                          levelId: order.shopper.levelId)
                                      : 0)),
                              style: profitStyle))
                    ],
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    LabelRow(
                      rightSideText: phoneNumberString,
                      leftSideText: order.userData.phone,
                      leftSideStyle: paragraphStyle.copyWith(color: kmColors),
                      onTap: () => Services.makePhoneCall(order.userData.phone),
                    ),
                    if (Services.hasRole(context, operationManagerRole))
                      InkWell(
                        child: Icon(Icons.copy, color: kmColors, size: 25),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: order.userData.phone));
                          Toast.show('تم نسخ الرقم', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                        },
                      ),
                    if (Services.hasRole(context, agentRole))
                      InkWell(
                        child: Icon(Icons.manage_accounts_rounded, color: kmColors, size: 25),
                        onTap: () {
                          StoreProvider.of<AppState>(context).dispatch(
                              SetUser(userEntity: UserEntity(id: order.userData.id, balance: order.userData.balance)));
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => UserManagement(order: order)));
                          StoreProvider.of<AppState>(context).dispatch(FirstCouponsPage());
                          StoreProvider.of<AppState>(context).dispatch(GetCouponsAction());
                          StoreProvider.of<AppState>(context).dispatch(GetUserCouponsAction(userId: order.userData.id));
                        },
                      ),
                    if (Services.hasRole(context, operationManagerRole))
                      MediaIcon(
                          icon: FontAwesomeIcons.whatsapp,
                          url: 'customer_whatsapp',
                          mobileNumber: order.userData.phone),
                    if (Services.hasRole(context, operationManagerRole))
                      InkWell(
                        child: Icon(Icons.search_rounded, color: kmColors, size: 30),
                        onTap: () {
                          if (pop) Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (screenContext) =>
                                      PhoneNumberOrdersView(phoneNumber: order.userData.phone)));
                        },
                      ),
                    if (order.address.lat != -1 && order.address.lon != -1)
                      InkWell(
                          child: Icon(Icons.location_on, color: kmColors, size: 30),
                          onTap: () => openMapsSheet(context: context, lat: order.address.lat, lon: order.address.lon)),
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
                  leftSideText: StaticVariables.supportedCitiesListIntro
                          .where((supportedCity) => supportedCity.id == order.supportedCityId)
                          .first
                          .name +
                      '   ',
                  leftSideStyle: informationStyle),
              LabelRow(rightSideText: entrance, leftSideText: order.address.entrance, leftSideStyle: informationStyle),
              LabelRow(
                  rightSideText: orderDate,
                  leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(order.createdAt),
                  leftSideStyle: disableStyle),
              LabelRow(rightSideText: orderStatus, leftSideText: '', leftSideStyle: informationStyle),
              if (Services.hasRole(context, operationManagerRole) && order.orderStatusId == '5')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelRow(
                      rightSideText: 'بين قبول الطلب وتوصيله : ',
                      leftSideText: '  ' +
                          order.deliveredAt.difference(order.acceptedAt).inHours.toString() +
                          ':' +
                          (order.deliveredAt.difference(order.acceptedAt).inMinutes -
                                  (order.deliveredAt.difference(order.acceptedAt).inHours * 60))
                              .toString(),
                      leftSideStyle: (order.deliveryMethodId == '2' &&
                              order.deliveredAt.difference(order.acceptedAt).inMinutes > 45)
                          ? warningStyle
                          : (order.deliveryMethodId == '1' &&
                                  order.deliveredAt.difference(order.acceptedAt).inMinutes > 90)
                              ? warningStyle
                              : disableStyle,
                    ),
                    LabelRow(
                      rightSideText: 'بين إنشاء الطلب وتوصيله : ',
                      leftSideText: '  ' +
                          order.deliveredAt.difference(order.createdAt).inHours.toString() +
                          ':' +
                          (order.deliveredAt.difference(order.createdAt).inMinutes -
                                  (order.deliveredAt.difference(order.createdAt).inHours * 60))
                              .toString(),
                      leftSideStyle: (order.deliveryMethodId == '2' &&
                              order.deliveredAt.difference(order.createdAt).inMinutes > 45)
                          ? warningStyle
                          : (order.deliveryMethodId == '1' &&
                                  order.deliveredAt.difference(order.createdAt).inMinutes > 90)
                              ? warningStyle
                              : disableStyle,
                    ),
                  ],
                ),
              LabelRow(
                  rightSideText: 'مسافة التوصيل : ',
                  leftSideText: (int.parse(order.deliveryDistance) / 1000).toString() + ' كم ',
                  leftSideStyle: informationStyle),
              if (Services.hasRole(context, operationManagerRole))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (order.shopper != null)
                      if (int.parse(order.orderStatusId) < 5)
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: KammunButton(
                                color: kmColors,
                                width: MediaQuery.of(context).size.width / 4,
                                text: 'تحويل',
                                onTap: () {
                                  showMyDialog(
                                      context: context,
                                      title: 'تحويل',
                                      text: 'هل أنت متأكد من رغبتك في تحويل الطلب لكابتن جديد ؟',
                                      dialogButtons: [
                                        KammunButton(
                                            color: kmColors,
                                            onTap: () {
                                              Navigator.pop(context);
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(ReAssignOrderAction(orderId: order.id, context: context));
                                            },
                                            width: 100,
                                            text: yes),
                                        KammunButton(
                                            color: kmColors, onTap: () => Navigator.pop(context), width: 100, text: no),
                                      ]);
                                })),
                    if (Services.hasRole(context, agentRole))
                      if (order.shopper != null)
                        if (order.shopper.admin != null)
                          if (order.shopper.admin.phone != null)
                            Wrap(
                              children: [
                                InkWell(
                                  child: Icon(Icons.contact_phone_rounded, color: kmColors),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: order.shopper.admin.phone));
                                    Toast.show('تم نسخ رقم الكابتن', context,
                                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_rounded, color: kmColors),
                                    onTap: () => Services.makePhoneCall(order.shopper.admin.phone),
                                  ),
                                ),
                              ],
                            ),
                    Expanded(
                      child: KSearchableDropdown(
                        hint: order.shopper != null ? order.shopper.name : chooseShopper,
                        search: shopper,
                        items: Services.shoppersNameList(context),
                        onChanged: (value) async {
                          if (value != null) {
                            String shopperId = Services.selectedShopperId(value, context);
                            int shopperLevelId = Services.selectedShopperLevelId(value, context);
                            shopper = value;
                            order.shopper = Assigned(
                                name: value.replaceAll(' ✅', '').replaceAll(' ❌', ''),
                                id: int.parse(shopperId),
                                levelId: shopperLevelId);
                            bool result =
                                await OrderServices.assignOrderToShopperService(shopperId, order.id.toString());
                            if (result) {
                              snackBar(success: result, message: 'تم إسناد الطلب بنجاح', context: context);
                            } else {
                              snackBar(
                                  success: result,
                                  message: 'فشلت عملية إسناد الطلب يرجى المحاولة مجدداً',
                                  context: context);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

openMapsSheet({context, double lat, double lon}) async {
  try {
    final coords = Coords(lat, lon);
    const title = 'Ocean Beach';
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                for (var map in availableMaps)
                  ListTile(
                      onTap: () => map.showMarker(coords: coords, title: title),
                      title: Text(map.mapName),
                      leading: const Icon(Icons.map))
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
/**/
  }
}
