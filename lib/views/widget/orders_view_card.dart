import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/service.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/order_details/order_details_tab_view.dart';
import 'package:kammun_app/views/orders/orders_view_importer.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/widget/close_widget.dart';
import 'package:map_launcher/map_launcher.dart';

class OrdersViewCard extends StatefulWidget {
  final OrdersOriginalData orderData;
  final OrderTypes orderType;
  final bool pop;

  const OrdersViewCard({Key key, @required this.orderData, @required this.orderType, this.pop}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrdersViewCardState();
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

class OrdersViewCardState extends State<OrdersViewCard> {
  int deletedCount;

  @override
  void initState() {
    deletedCount = widget.orderData.products.where((product) => product.pivot.deletedAt != 'null').length;
    super.initState();
  }

  String orderStatus = 'طلبك قيد المعالجة ⌛️';

  @override
  Widget build(BuildContext context) {
    switch (widget.orderData.orderStatusId) {
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
    }
    switch (widget.orderData.underUpdate) {
      case '1':
        orderStatus = 'الطلب معلق حتى يأكد الزبون التعديل';
        break;
      case '2':
        orderStatus = 'الطلب معلق حتى تقوم بتأكيد التعديل';
        break;
    }

    Color color = widget.orderData.userData.orderCount <= 3 && !widget.orderData.userData.orderCount.isNegative
        ? ColorUtils.kmColors2
        : widget.orderData.deliveryMethodId == '2'
            ? Colors.red[700]
            : widget.orderData.deliveryMethodId == '3'
                ? Colors.green
                : Colors.red[500];
    String shopper;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsTabView(
                  orderData: widget.orderData,
                  subTotal: int.parse(widget.orderData.total.toString().split('.')[0]) -
                      int.parse(widget.orderData.supportedCityCost.toString().split('.')[0]) -
                      int.parse(widget.orderData.deliveryCost.split('.')[0]),
                  total: widget.orderData.total.toString(),
                  orderType: widget.orderType))),
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
                    rightSideText: StringUtils.bill,
                    leftSideText:
                        '${StringUtils().oCcy.format(int.parse(widget.orderData.cashValue.split('.')[0]).abs()).toString()}'
                        ' ${LoadingScreenServices.companyInformation.currency.toString()}',
                    leftSideStyle: int.parse(widget.orderData.cashValue.split('.')[0]).isNegative
                        ? informationStyle.copyWith(color: Colors.red)
                        : informationStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(border: Border.all(color: ColorUtils.greyColor.withOpacity(0.2))),
                    child: Text(
                      widget.orderData.products.where((product) => product.pivot.deletedAt == 'null').length.toString(),
                      style: paragraphStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if ((Services.isAdmin() || Services.isOperationManager()) && deletedCount > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(border: Border.all(color: Colors.red.withOpacity(0.2))),
                      child: Text(deletedCount.toString(),
                          style: loseStyle.copyWith(fontSize: 18), textAlign: TextAlign.center),
                    ),
                  if (Services.isOperationManager() &&
                      (widget.orderData.userDeliveryRating != 'null' || widget.orderData.userFeedback != 'null'))
                    IconButton(
                      icon: Icon(Icons.star, color: ColorUtils.kmColors2, size: 30),
                      padding: EdgeInsets.zero,
                      onPressed: () => showMyDialog(
                        title: StringUtils.ratingOrder,
                        text: (widget.orderData.userDeliveryRating != 'null'
                                ? widget.orderData.userDeliveryRating + '\n'
                                : '') +
                            (widget.orderData.userFeedback != 'null' ? widget.orderData.userFeedback + '\n' : ''),
                        dialogButtons: [const CloseWidget()],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.orderData.id.toString().length >= 3
                            ? '#${widget.orderData.id.toString().substring(widget.orderData.id.toString().length - 3, widget.orderData.id.toString().length)}'
                            : '#${widget.orderData.id.toString()}',
                        style: profitStyle.copyWith(color: Colors.purple),
                      ),
                      RichText(
                          text: TextSpan(
                              text: StringUtils().oCcy.format(widget.orderData.shopperProfit).toString(),
                              style: profitStyle))
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LabelRow(
                    rightSideText: StringUtils.phoneNumber,
                    leftSideText: widget.orderData.userData.phone,
                    leftSideStyle: paragraphStyle.copyWith(color: ColorUtils.kmColors),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Services.makePhoneCall(widget.orderData.userData.phone),
                  ),
                  if (Services.isOperationManager())
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy, color: ColorUtils.kmColors, size: 25),
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.orderData.userData.phone));
                            Toast.show('تم نسخ الرقم', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          },
                        ),
                        MediaIcon(
                            icon: FontAwesomeIcons.whatsapp,
                            url: 'customer_whatsapp',
                            mobileNumber: widget.orderData.userData.phone),
                        IconButton(
                          icon: Icon(Icons.search_rounded, color: ColorUtils.kmColors, size: 30),
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            LoadingScreenServices.allOrdersList.clear();
                            if (widget.pop) Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (screenContext) =>
                                        PhoneNumberOrdersView(phoneNumber: widget.orderData.userData.phone)));
                          },
                        ),
                      ],
                    ),
                  if (widget.orderData.address.lat != -1 && widget.orderData.address.lon != -1)
                    IconButton(
                        icon: Icon(Icons.location_on, color: ColorUtils.kmColors, size: 30),
                        padding: const EdgeInsets.all(0),
                        onPressed: () => openMapsSheet(
                            context: context, lat: widget.orderData.address.lat, lon: widget.orderData.address.lon)),
                ],
              ),
              LabelRow(
                  rightSideText: StringUtils.address + ' : ',
                  leftSideText: widget.orderData.address.street +
                      ' ' +
                      widget.orderData.address.building +
                      ' طابق ' +
                      widget.orderData.address.floor +
                      ' ' +
                      widget.orderData.address.description,
                  leftSideStyle: informationStyle),
              LabelRow(
                  rightSideText: StringUtils.city,
                  leftSideText: LoadingScreenServices.supportedCitiesListIntro
                          .where((supportedCity) => supportedCity.id == widget.orderData.supportedCityId)
                          .first
                          .name +
                      '   ',
                  leftSideStyle: informationStyle),
              LabelRow(
                  rightSideText: StringUtils.entrance,
                  leftSideText: widget.orderData.address.entrance,
                  leftSideStyle: informationStyle),
              LabelRow(
                  rightSideText: StringUtils.orderDate,
                  leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(widget.orderData.createdAt),
                  leftSideStyle: disableStyle),
              LabelRow(rightSideText: orderStatus, leftSideText: '', leftSideStyle: informationStyle),
              if (Services.isOperationManager() && widget.orderData.orderStatusId == '5')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelRow(
                      rightSideText: 'بين قبول الطلب وتوصيله : ',
                      leftSideText: '  ' +
                          widget.orderData.deliveredAt.difference(widget.orderData.acceptedAt).inHours.toString() +
                          ':' +
                          (widget.orderData.deliveredAt.difference(widget.orderData.acceptedAt).inMinutes -
                                  (widget.orderData.deliveredAt.difference(widget.orderData.acceptedAt).inHours * 60))
                              .toString(),
                      leftSideStyle: (widget.orderData.deliveryMethodId == '2' &&
                              widget.orderData.deliveredAt.difference(widget.orderData.acceptedAt).inMinutes > 45)
                          ? warningStyle
                          : (widget.orderData.deliveryMethodId == '1' &&
                                  widget.orderData.deliveredAt.difference(widget.orderData.acceptedAt).inMinutes > 90)
                              ? warningStyle
                              : disableStyle,
                    ),
                    LabelRow(
                      rightSideText: 'بين إنشاء الطلب وتوصيله : ',
                      leftSideText: '  ' +
                          widget.orderData.deliveredAt.difference(widget.orderData.createdAt).inHours.toString() +
                          ':' +
                          (widget.orderData.deliveredAt.difference(widget.orderData.createdAt).inMinutes -
                                  (widget.orderData.deliveredAt.difference(widget.orderData.createdAt).inHours * 60))
                              .toString(),
                      leftSideStyle: (widget.orderData.deliveryMethodId == '2' &&
                              widget.orderData.deliveredAt.difference(widget.orderData.createdAt).inMinutes > 45)
                          ? warningStyle
                          : (widget.orderData.deliveryMethodId == '1' &&
                                  widget.orderData.deliveredAt.difference(widget.orderData.createdAt).inMinutes > 90)
                              ? warningStyle
                              : disableStyle,
                    ),
                  ],
                ),
              if (Services.isOperationManager())
                KSearchableDropdown(
                  hint: widget.orderData.shopper != null ? widget.orderData.shopper.name : StringUtils.chooseShopper,
                  search: shopper,
                  items: Services.shoppersNameList(),
                  onChanged: (value) async {
                    if (value != null) {
                      String shopperId = Services.selectedShopperId(value);
                      int shopperLevelId = Services.selectedShopperLevelId(value);
                      setState(() {
                        shopper = value;
                        widget.orderData.shopper = Assigned(
                            name: value.replaceAll(' ✅', '').replaceAll(' ❌', ''),
                            id: int.parse(shopperId),
                            levelId: shopperLevelId);
                      });
                      bool result =
                          await OrderServices.assignOrderToShopperService(shopperId, widget.orderData.id.toString());
                      Services.resultFlushBar(context: context, result: result);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
