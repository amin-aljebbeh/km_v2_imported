import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  List<OrderProducts> ordersAry;
  int subTotal;
  String total;
  String deliveryPrice;

  OrderDetailView({this.ordersAry, this.subTotal, this.total, this.deliveryPrice});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewState();
  }
}

class OrderDetailViewState extends State<OrderDetailView> {
  List<OrderProducts> productsAry;

  @override
  void initState() {
    super.initState();

    setState(() {
      productsAry = widget.ordersAry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        StringUtils.orderDetail,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 30),
                      )),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productsAry == null ? 0 : productsAry.length,
                  itemBuilder: (BuildContext context, int index) {
                    OrderProducts orderDetail = productsAry[index];
                    return new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: OrderDetailViewCard(
                        img: orderDetail.images.length != 0
                            ? LoadingScreenServices.imagePrefixUrl + orderDetail.images[0].imageFileName
                            : "",
                        productName: orderDetail.name,
                        quantity: orderDetail.quantity,
                        price: int.parse(orderDetail.pivot.purchasePrice),
                        unit: orderDetail.unit == null ? "" : orderDetail.unit,
                        productCount: orderDetail.pivot.quantity.toString(),
                        index: index,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(StringUtils.subtotal,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 17.0,
                        )),
                    Text(
                      StringUtils().oCcy.format(widget.subTotal).toString() +
                          " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 17.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(StringUtils.delivery,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 16.0,
                        )),
                    Text(
                      widget.deliveryPrice + " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(StringUtils.total,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 19.0,
                        )),
                    Text(
                      "${StringUtils().oCcy.format(int.parse(widget.total))}" +
                          " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 19),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // _showReOrderButton(),
            ],
          ),
        ),
      ),
    );
  }
}
