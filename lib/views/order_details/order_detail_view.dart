import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

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
    // TODO: implement build
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
                        UtilsImporter().stringUtils.orderDetail,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
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
                      onTap: () => _onTileClicked(index),
                      child: OrderDetailViewCard(
                        img: orderDetail.images.length != 0
                            ? LoadingScreenServices.imagePrefixUrl + orderDetail.images[0].imageFileName
                            : "",
                        product_name: orderDetail.name,
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
                    Text(UtilsImporter().stringUtils.subtotal,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                          fontSize: 17.0,
                        )),
                    Text(
                      UtilsImporter().stringUtils.oCcy.format(widget.subTotal).toString() +
                          " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
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
                    Text(UtilsImporter().stringUtils.delivery,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                          fontSize: 16.0,
                        )),
                    Text(
                      widget.deliveryPrice + " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
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
                    Text(UtilsImporter().stringUtils.total,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                          fontSize: 19.0,
                        )),
                    Text(
                      "${UtilsImporter().stringUtils.oCcy.format(int.parse(widget.total))}" +
                          " ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
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

  void _onTileClicked(int index) {}
}

class OrderDetailViewCard extends StatefulWidget {
  final String img;
  final String product_name;
  final String quantity;
  final int price;
  final int index;
  final String unit;
  final String productCount;

  OrderDetailViewCard(
      {this.img, this.product_name, this.quantity, this.price, this.index, this.unit, this.productCount});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderDetailViewCardState();
  }
}

class OrderDetailViewCardState extends State<OrderDetailViewCard> {
  int no_of_orders = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                          tag: widget.index + 100,
                          child: FadeInImage(
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: AssetImage("assets/kmIcon.png"),
                            fit: BoxFit.contain,
                            image:
                                widget.img.length > 0 ? NetworkImage(widget.img) : AssetImage("assets/kmIcon.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ))),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Text(
                                widget.product_name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity + " " + widget.unit,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: UtilsImporter().colorUtils.greycolor,
                                fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              UtilsImporter().stringUtils.oCcy.format(widget.price).toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: UtilsImporter().colorUtils.primarycolor,
                                  fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                              ),
                      border: Border.all(color: UtilsImporter().colorUtils.primarycolor, width: 2)),
                  child: Center(
                      child: Text(
                    widget.productCount,
                    style: TextStyle(fontSize: 25),
                  )),
                )
              ],
            ),
            SizedBox(height: 4),
            Divider()
          ],
        ),
      ),
    );
  }
}
