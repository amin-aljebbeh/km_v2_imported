import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/CartViewFinal.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/deliver_to/delivery_method.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'services/cart_services.dart';

class CartView extends StatefulWidget {
  final bool isFromUpdateOrder;
  CartView({this.isFromUpdateOrder = false});
  @override
  State<StatefulWidget> createState() {
    return CartViewState();
  }
}

class CartViewState extends State<CartView> {
  List<ProductsData> orderArray;
  int subtotal = 0;
  int delivaryCost = 10;
  static List<int> cards = [];

  makeCards() {
    cards = [];
    for (int i = 0; i < orderArray.length; i++) {
      cards.add(i);
    }
  }

  _cartChanged() async {
    String products_Id = "";
    String products_quantity = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      products_Id += CartServices.cartProducts[i].id.toString() + ";";
      products_quantity +=
          CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", products_Id + "@" + products_quantity);
  }

  _showUpdateOrderInstruction({BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "انت تقوم حالياً بتعديل طلبك",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(
                      //             5.0) //         <--- border radius here
                      //         ),
                      //     border: Border.all(
                      //       width: 2,
                      //       color: UtilsImporter().colorUtils.kmColors,
                      //     )),
                      child: Text(
                        "بإمكانك إضافة أو حذف او تعديل المنتجات الخاصة بك ضمن سلة المشتريات بالشكل الطبيعي الذي تقوم به عادة",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18),
                      ),
                    ),
                    //  _saveNotes(context: context),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    orderArray = CartServices.cartProducts;
    makeCards();

    for (int i = 0; i < orderArray.length; i++) {
      subtotal = subtotal +
          ((int.parse(orderArray[i].warehouses[0].pivot.price.split(".")[0])) *
              orderArray[i].productCount);
    }
    print(widget.isFromUpdateOrder);
    widget.isFromUpdateOrder
        ? WidgetsBinding.instance.addPostFrameCallback(
            (_) => _showUpdateOrderInstruction(context: context))
        : {};
  }

  void onrRemove(item) {
    setState(() {
      cards.removeAt(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        UtilsImporter().stringUtils.shoppingcart,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
                CartServices.cartProducts.length == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: screenHight * 0.3),
                        child: Center(
                          child: Text(
                            "سلة المشتريات فارغة",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: UtilsImporter().colorUtils.greycolor,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.zero,
                      ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: orderArray == null ? 0 : cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _onTileClicked(index),
                        child: Container(
                          //  color: Theme.of(context).primaryColorLight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                            child: cardBody(index, context),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(UtilsImporter().stringUtils.subtotal,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 19.0,
                        )),
                    Text(
                      "${UtilsImporter().stringUtils.oCcy.format(subtotal)} ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 19),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SafeArea(
                  child: _showConfirmOrderButton(),
                  top: false,
                ),
              ],
            ),
          ),
        ));
  }

  Widget cardBody(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: index + 100,
                    child: FadeInImage(
                        image: orderArray[index].images.length != 0
                            ? NetworkImage(
                                LoadingScreenServices.imagePrefixUrl +
                                    orderArray[index]
                                        .images[0]
                                        .imageFileName
                                        .toString(),
                              )
                            : AssetImage("assets/kmIcon.png"),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        fadeInCurve: Curves.fastOutSlowIn,
                        placeholder: AssetImage("assets/kmIcon.png"),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              // SizedBox(width: 10),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              children: [
                                Text(
                                  orderArray[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              orderArray[index].quantity.toString() +
                                  " " +
                                  orderArray[index].unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: UtilsImporter().colorUtils.greycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Text(
                                "${UtilsImporter().stringUtils.oCcy.format(int.parse(orderArray[index].warehouses[0].pivot.price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18)),
                            //SizedBox(height: 8),
                            // IconButton(
                            //   icon: Icon(Icons.delete_forever),
                            //   color: Colors.red,
                            //   onPressed: () {},
                            //     iconSize: 30,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UtilsImporter()
                            .colorUtils
                            .greycolor
                            .withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          orderArray[index].productCount += 1;
                          subtotal += (int.parse(orderArray[index]
                              .warehouses[0]
                              .pivot
                              .price
                              .split(".")[0]));
                        });
                        _cartChanged();
                      },
                      child: Image.asset(
                        "assets/add.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(orderArray[index].productCount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 18)),
                  SizedBox(height: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UtilsImporter()
                            .colorUtils
                            .greycolor
                            .withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (orderArray[index].productCount > 1) {
                            subtotal -= (int.parse(orderArray[index]
                                .warehouses[0]
                                .pivot
                                .price
                                .split(".")[0]));
                            orderArray[index].productCount =
                                orderArray[index].productCount - 1;
                          } else if (orderArray[index].productCount == 1) {
                            subtotal -= (int.parse(orderArray[index]
                                .warehouses[0]
                                .pivot
                                .price
                                .split(".")[0]));
                            onrRemove(index);
                            CartServices.cartProducts.removeAt(index);
                          }
                        });
                        _cartChanged();
                      },
                      child: orderArray[index].productCount > 1
                          ? Image.asset(
                              "assets/remove.png",
                              width: 60,
                              height: 60,
                            )
                          : Icon(
                              Icons.delete_forever,
                              size: 30,
                              color: Colors.red,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }

  // Function to be called on click
  void _onTileClicked(int index) {
    debugPrint("You tapped on item $index");
    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) =>
    //             new ProductDetailView(heroIndex: index + 100)));
  }

  void _showConfirmOrderBtnTapped() {
    if (CartServices.cartProducts.length > 0) {
      print(
          "the orderUnderUpdateIndex value is : ${OrderServices.orderUnderUpdateIndex}");
      if (OrderServices.orderUnderUpdateIndex == -1) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new DeliverToView()));
      } else {
        if (LoadingScreenServices.deliveryMethodsList.length != 1) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DeliveryMethodView()));
        } else {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new CartViewFinal()));
        }
      }
    } else {
      Toast.show("يرجى إضافة منتج واحد على الأقل", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  // DeliverToView.selectedIndex != null
  //               ? UtilsImporter().colorUtils.primarycolor
  //               : Colors.grey[400]

  Widget _showConfirmOrderButton() {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: _showConfirmOrderBtnTapped,
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: CartServices.cartProducts.length > 0
                ? UtilsImporter().colorUtils.primarycolor
                : Colors.grey[400],
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.confirm_order.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showConfirmButtonWithGesture);
  }
}
