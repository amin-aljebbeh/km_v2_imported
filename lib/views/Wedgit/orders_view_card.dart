import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/KSearchableDropdown.dart';
import 'package:kammun_app/views/Wedgit/decision_button.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Services.dart';
import '../../utils/Styles.dart';

class OrdersViewCard extends StatefulWidget {
  int orderId;
  final String userNumber;
  final int deliveryMethodId;
  String deliveryName;
  String shopperName;
  int orderQuantity;
  String orderTitle;
  String orderTotalPrice;
  int orderStatus;
  String orderCreatedDate;
  int underUpdate;
  String supportedCityId;
  final String address;
  final double lat;
  final double lon;
  final String entrance;

  OrdersViewCard({
    @required this.orderId,
    this.orderQuantity,
    this.orderTitle,
    this.orderTotalPrice,
    this.orderStatus,
    this.orderCreatedDate,
    this.supportedCityId,
    this.address,
    this.lat,
    this.lon,
    this.userNumber,
    this.deliveryMethodId,
    @required this.entrance,
    this.underUpdate,
    this.shopperName,
    this.deliveryName,
  });

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

_makePhoneCall(String number) async {
  String url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openMapsSheet(context, lat, lon) async {
  try {
    final coords = Coords(lat, lon);
    final title = "Ocean Beach";
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: Icon(Icons.map),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    print(e);
  }
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String shopperName, deliveryName;
  SearchableItem deliverySearch, shopperSearch;

  void initState() {
    shopperName = widget.shopperName != null ? widget.shopperName : null;
    deliveryName = widget.deliveryName != null ? widget.deliveryName : null;
    super.initState();
  }

  String orderStatus = "طلبك قيد المعالجة ⌛️";

  @override
  Widget build(BuildContext context) {
    if (widget.orderStatus == 2) orderStatus = "تم قبول الطلب من قبل "; //✅
    if (widget.orderStatus == 3)
      orderStatus = "تم تجهيز الطلب من قبل إبراهيم"; //😎
    if (widget.orderStatus == 4) orderStatus = "تم إرسال طلبك مع الكابتن محمد";
    if (widget.underUpdate == 1)
      orderStatus = "الطلب معلق حتى يأكد الزبون التعديل";

    if (widget.underUpdate == 2)
      orderStatus = "الطلب معلق حتى تقوم بتأكيد التعديل";

    if (widget.orderStatus == 5) orderStatus = "تم توصيل الطلب بنجاح من قبل ";
    if (widget.orderStatus == 6) orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
    if (widget.orderStatus == 7) orderStatus = "😔 لم نستطع تأمين الطلب 😔";

    return Container(
      decoration: widget.deliveryMethodId == 2
          ? BoxDecoration(border: Border.all(color: Colors.red, width: 5))
          : widget.deliveryMethodId == 3
              ? BoxDecoration(border: Border.all(color: Colors.green, width: 5))
              : BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 5)),
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "الفاتورة : ",
                                            style: paragraphStyle,
                                          ),
                                          TextSpan(
                                            text: "${UtilsImporter().stringUtils.oCcy.format(int.parse(widget.orderTotalPrice)).toString()}" +
                                                " ${LoadingScreenServices.companyInformation.currency.toString()}",
                                            style: informationStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: UtilsImporter()
                                                .colorUtils
                                                .greycolor
                                                .withOpacity(0.2)),
                                      ),
                                      child: Text(
                                        widget.orderQuantity.toString(),
                                        style: paragraphStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "#${widget.orderId.toString().substring(3, widget.orderId.toString().length)}",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk,
                                        ),
                                      ),
                                    )
                                  ]),
                              SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "رقم الهاتف : ",
                                            style: paragraphStyle,
                                          ),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => _makePhoneCall(
                                                  widget.userNumber),
                                            text: widget.userNumber,
                                            style: TextStyle(
                                              color: UtilsImporter()
                                                  .colorUtils
                                                  .kmColors,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: UtilsImporter()
                                                  .stringUtils
                                                  .HKGrotesk,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              SizedBox(height: 10),
                              Wrap(children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "العنوان : ",
                                        style: paragraphStyle,
                                      ),
                                      TextSpan(
                                        text: widget.address,
                                        style: informationStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "المدينة: ",
                                          style: paragraphStyle,
                                        ),
                                        TextSpan(
                                          text: LoadingScreenServices
                                                  .supportedCitiesListIntro
                                                  .where((supportedCity) =>
                                                      supportedCity.id
                                                          .toString() ==
                                                      widget.supportedCityId)
                                                  .first
                                                  .name +
                                              "   ",
                                          style: informationStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.lat != null && widget.lon != null
                                      ? InkWell(
                                          child: Icon(
                                            Icons.delivery_dining,
                                            color: Colors.blue,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            openMapsSheet(context, widget.lat,
                                                widget.lon);
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "المدخل: ",
                                      style: paragraphStyle,
                                    ),
                                    TextSpan(
                                      text: widget.entrance,
                                      style: informationStyle,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "تاريخ الطلب : ",
                                      style: paragraphStyle,
                                    ),
                                    TextSpan(
                                      text: widget.orderCreatedDate,
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                orderStatus,
                                style: paragraphStyle,
                              ),
                              Row(
                                children: [
                                  Text(
                                    UtilsImporter().stringUtils.deliveryName +
                                        " ",
                                    style: paragraphStyle,
                                  ),
                                  Text(
                                    deliveryName != null ? deliveryName : " ",
                                    style: paragraphStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    UtilsImporter().stringUtils.shopperName +
                                        " ",
                                    style: paragraphStyle,
                                  ),
                                  Text(
                                    shopperName != null ? shopperName : " ",
                                    style: paragraphStyle,
                                  ),
                                ],
                              ),
                              //supportedCitiesResponse
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * .6,
              child: (Services.roles
                              .where((element) => element.slug.contains(
                                  UtilsImporter().stringUtils.superAdminRole))
                              .length >
                          0) ||
                      (Services.roles
                              .where((element) => element.slug.contains(
                                  UtilsImporter().stringUtils.adminRole))
                              .length >
                          0)
                  ? Column(
                      children: [
                        shopperName == null
                            ? KSearchableDropdown(
                                hint: UtilsImporter().stringUtils.chooseShopper,
                                search: shopperSearch,
                                items: Services.shoppersNameList(
                                    LoadingScreenServices.allShoppers),
                                onChange: (value) {
                                  setState(() {
                                    shopperSearch = value;
                                    shopperName = value.value;
                                  });
                                  OrderServices.assignOrderToShopper(
                                      LoadingScreenServices.allShoppers
                                          .firstWhere((element) =>
                                              element.name == value.value)
                                          .id
                                          .toString(),
                                      widget.orderId.toString());
                                },
                              )
                            : Container(
                                height: 0.5,
                                width: 0.5,
                              ),
                        deliveryName == null
                            ? KSearchableDropdown(
                                hint:
                                    UtilsImporter().stringUtils.chooseDelivery,
                                search: deliverySearch,
                                items: Services.deliveriesNameList(
                                    LoadingScreenServices.allDeliveries),
                                onChange: (value) {
                                  setState(() {
                                    deliverySearch = value;
                                    deliveryName = value.value;
                                  });
                                  OrderServices.assignOrderToDelivery(
                                      LoadingScreenServices.allDeliveries
                                          .firstWhere((element) =>
                                              element.name == value.value)
                                          .id
                                          .toString(),
                                      widget.orderId.toString());
                                },
                              )
                            : Container(
                                height: 0.5,
                                width: 0.5,
                              ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
