import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Wedgit/k_cache_image.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/Wedgit/screen_message.dart';
import 'package:kammun_app/views/cart/CartViewFinal.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/services/order_details_services.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'services/cart_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class CartView extends StatefulWidget {
  final bool isFromUpdateOrder;

  CartView({this.isFromUpdateOrder = false});

  @override
  State<StatefulWidget> createState() {
    return CartViewState();
  }
}

class CartViewState extends State<CartView> {
  List<ProductData> orderArray;
  int subtotal = 0;
  int deliveryCost = 10;
  static List<int> cards = [];
  int indexToEdit = -1;

  makeCards() {
    cards = [];
    for (int i = 0; i < orderArray.length; i++) {
      cards.add(i);
    }
  }

  _cartChanged() async {
    String productsId = "";
    String productsQuantity = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ";";
      productsQuantity +=
          CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", productsId + "@" + productsQuantity);
  }

  _calculateTotal() {
    subtotal = 0;

    setState(() {
      for (int i = 0; i < orderArray.length; i++) {
        subtotal = subtotal +
            ((int.parse(orderArray[i].price.split(".")[0])) *
                orderArray[i].productCount);
      }
    });
  }

  @override
  void initState() {
    printCart();
    super.initState();
    orderArray = CartServices.cartProducts;

    if (LoadingScreenServices.subWarehouses.length == 1) {
      orderArray.sort((a, b) {
        if (a.subWarehouseId > b.subWarehouseId) {
          return -1;
        } else if (a.subWarehouseId < b.subWarehouseId) {
          return 1;
        } else
          return 0;
      });
    } else {
      orderArray.sort((a, b) {
        if (a.subWarehouseId > b.subWarehouseId) {
          return 1;
        } else if (a.subWarehouseId < b.subWarehouseId) {
          return -1;
        } else
          return 0;
      });
    }
    makeCards();

    for (int i = 0; i < orderArray.length; i++) {
      subtotal = subtotal +
          ((int.parse(orderArray[i].price.split(".")[0])) *
              orderArray[i].productCount);
    }

    // Tools.logToConsole(widget.isFromUpdateOrder);
    // widget.isFromUpdateOrder
    //     ? WidgetsBinding.instance.addPostFrameCallback(
    //         (_) => _showUpdateOrderInstruction(context: context))
    //     : {};
  }

  void onrRemove(item) {
    setState(() {
      cards.removeAt(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
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
                        StringUtils.shoppingCart,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: StringUtils.HKGrotesk,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
                CartServices.cartProducts.length == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.3),
                        child: Center(
                            child:
                                ScreenMessage(message: 'سلة المشتريات فارغة')),
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
                    Text(StringUtils.subtotal,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.HKGrotesk,
                          fontSize: 19.0,
                        )),
                    Text(
                      "${StringUtils().oCcy.format(subtotal)} ${LoadingScreenServices.companyInformation.currency}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: StringUtils.HKGrotesk,
                          fontSize: 19),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SafeArea(
                  child: KammunButton(
                    width: MediaQuery.of(context).size.width,
                    color: CartServices.cartProducts.length > 0
                        ? ColorUtils.primaryColor
                        : Colors.grey[400],
                    text: StringUtils.confirmOrder.toUpperCase(),
                    onTap: _showConfirmOrderBtnTapped,
                    height: 50,
                  ),
                  top: false,
                ),
              ],
            ),
          ),
        ));
  }

  TextEditingController _priceController = new TextEditingController();

  //TODO: make widget
  Widget cardBody(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              KCacheImage(
                tag: index + 100,
                image: LoadingScreenServices.imagePrefixUrl +
                    orderArray[index].images[0].imageFileName,
              ),
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
                                      fontFamily: StringUtils.HKGrotesk,
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
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.HKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                indexToEdit == index
                                    ? Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: TextFormField(
                                            controller: _priceController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                              hintText: "السعر الجديد",
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "${StringUtils().oCcy.format(int.parse(orderArray[index].price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.primaryColor,
                                            fontFamily: StringUtils.HKGrotesk,
                                            fontSize: 18)),
                                indexToEdit == index
                                    ? IconButton(
                                        icon: Icon(Icons.save_rounded),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            indexToEdit = -1;

                                            double priceFactor = double.parse(
                                                    orderArray[index]
                                                        .quantity) /
                                                double.parse(
                                                    orderArray[index].price);

                                            if (_priceController.text.length >
                                                0) {
                                              orderArray[index].price =
                                                  _priceController.text;

                                              orderArray[index].quantity =
                                                  (priceFactor *
                                                          double.parse(
                                                              _priceController
                                                                  .text))
                                                      .toStringAsFixed(2);

                                              OrderDetailsServices.updateOrder(
                                                  orderId: OrderServices
                                                      .orderUnderUpdateId,
                                                  context: context,
                                                  updateKey: "product_quantity",
                                                  updateValue: (priceFactor *
                                                          double.parse(
                                                              _priceController
                                                                  .text))
                                                      .toStringAsFixed(2),
                                                  productId: orderArray[index]
                                                      .id
                                                      .toString());

                                              // asdsa ads das sda a
                                            }
                                          });

                                          _priceController.text = "";

                                          _calculateTotal();
                                        },
                                        iconSize: 30,
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            indexToEdit = index;
                                          });

                                          _calculateTotal();
                                        },
                                        iconSize: 30,
                                      ),
                              ],
                            ),
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
                        color: ColorUtils.greyColor.withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          orderArray[index].productCount += 1;
                          subtotal += (int.parse(
                              orderArray[index].price.split(".")[0]));
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
                          fontFamily: StringUtils.HKGrotesk,
                          fontSize: 18)),
                  SizedBox(height: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorUtils.greyColor.withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (orderArray[index].productCount > 1) {
                            subtotal -= (int.parse(
                                orderArray[index].price.split(".")[0]));
                            orderArray[index].productCount =
                                orderArray[index].productCount - 1;
                          } else if (orderArray[index].productCount == 1) {
                            subtotal -= (int.parse(
                                orderArray[index].price.split(".")[0]));
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
    Tools.logToConsole("You tapped on item $index");
    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) =>
    //             new ProductDetailView(heroIndex: index + 100)));
  }

  void printCart() {
    Tools.logToConsole('cart');
    Tools.logToConsole(CartServices.cartProducts.length);
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      printProducts(CartServices.cartProducts[i]);
    }
  }

  void printProducts(ProductData product) {
    Tools.logToConsole(product.name);
    Tools.logToConsole(product.productCount);
  }

  void _showConfirmOrderBtnTapped() {
    if (CartServices.cartProducts.length > 0) {
      Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new CartViewFinal()))
          .then((onValue) {
        _calculateTotal();
      });
    } else {
      Toast.show("يرجى إضافة منتج واحد على الأقل", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }
}
