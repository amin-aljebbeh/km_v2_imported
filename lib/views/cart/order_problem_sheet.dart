import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/k_cache_image.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';

class OrderProblemBottomSheet extends StatefulWidget {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final Function(bool updatePrice) applyChanges;

  OrderProblemBottomSheet(
      {@required this.notActiveProducts,
      @required this.pricesChangesProducts,
      @required this.applyChanges});

  @override
  _OrderProblemBottomSheetState createState() =>
      _OrderProblemBottomSheetState();
}

class _OrderProblemBottomSheetState extends State<OrderProblemBottomSheet> {
  List<ProductData> orderArray;
  List<int> notActiveCards = [];
  List<int> priceCards = [];

  bool loadingScreen = false;
  bool errorCode = false;

  // List<ProductsData> notActive;
  // List<ProductsData> priceChanged;

  String dialogText;

  makeCards() {
    priceCards = [];
    notActiveCards = [];

    for (int i = 0; i < orderArray.length; i++) {
      if (widget.notActiveProducts.contains(orderArray[i].id)) {
        notActiveCards.add(i);
      }
      if (widget.pricesChangesProducts.contains(orderArray[i].id)) {
        priceCards.add(i);
      }
    }
    if (priceCards.length > 0 && notActiveCards.length == 0) {
      dialogText =
          "نأسف لحدوث ذلك ولكن أثناء قيامك بالتسوق تغير سعر  ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك مشاهدة تلك المنتجات و القيام بتحديث الطلب ليتم تحديث الأسعار او اختيار بدائل ";
    }
    if (notActiveCards.length > 0 && priceCards.length == 0) {
      dialogText =
          "نأسف لحدوث ذلك و لكن أثناء قيامك بالتسوق نفذ ${notActiveCards.length} من المنتجات التي قمت بإضافتها يمكنك تحديث الطلب لحذف هذه المنتجات او اختيار بدائل عنها من داخل التطبيق";
    }
    if (notActiveCards.length > 0 && priceCards.length > 0) {
      dialogText =
          "نأسف لحدوث ذلك ولكن أثناء قيامك بعملية التسوق نفذ ${notActiveCards.length} من المنتجات و تغير سعر ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك إختيار تحديث الطلب لمشاهدة الأسعار الجديدة و حذف المنتجات الغير متوفرة أو الضغط على إختيار بدائل لإضافتها من داخل التطبيق";
    }
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    makeCards();

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            List<DialogButton> dialogButtons = [
              DialogButton(
                text: "إغلاق",
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ];
            showMyDialog(
                title: "حدث خطأ بالطلب",
                text: "$dialogText",
                dialogButtons: dialogButtons,
                context: context);
          })
        : Tools.logToConsole('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              widget.notActiveProducts.length > 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          color: UtilsImporter().colorUtils.primaryColor,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                          )),
                      child: Center(
                          child: Text(
                        "منتجات نفذت أثناء التسوق",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      )),
                    )
                  : Container(),
              widget.notActiveProducts.length > 0
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: UtilsImporter().colorUtils.kmColors)),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              orderArray == null ? 0 : notActiveCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => _onTileClicked(index),
                              child: Container(
                                //  color: Theme.of(context).primaryColorLight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 0),
                                  child: cardBodyNotActive(
                                      notActiveCards[index], context),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),

              widget.notActiveProducts.length > 0
                  ? SizedBox(height: 10)
                  : Container(),
              widget.pricesChangesProducts.length > 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          color: UtilsImporter().colorUtils.kmColors,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                          )),
                      child: Center(
                          child: Text(
                        "منتجات تغير سعرها أثناء التسوق",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      )),
                    )
                  : Container(),

              // SizedBox(height: 10),
              widget.pricesChangesProducts.length > 0
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color:
                                    UtilsImporter().colorUtils.primaryColor)),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: orderArray == null ? 0 : priceCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => _onTileClicked(index),
                              child: Container(
                                //  color: Theme.of(context).primaryColorLight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 0),
                                  child: cardBodyPriceProblem(
                                      priceCards[index], context),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
              SafeArea(
                child: Center(
                  child: Wrap(
                    spacing: 5,
                    children: [
                      KammunButton(
                        text: "تحديث الطلب",
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.3,
                        color: Colors.green,
                        onTap: () => widget.applyChanges(false),
                      ),
                      KammunButton(
                        text: "!! إرسال الطلب !!",
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.3,
                        color: Colors.red,
                        onTap: () {
                          // KammunRestart.restartApp(context);
                          Navigator.of(context).pop();
                          widget.applyChanges(true);
                        },
                      ),
                    ],
                  ),
                ),
                top: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO:check if it possible to make widget
  Widget cardBodyNotActive(int index, BuildContext context) {
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
                    orderArray[index].images[0].imageFileName.toString(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              orderArray[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18),
                            ),
                            // SizedBox(height: 6),
                            Text(
                              orderArray[index].quantity.toString() +
                                  " " +
                                  orderArray[index].unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: UtilsImporter().colorUtils.greyColor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }

  Widget cardBodyPriceProblem(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                width: 75.0,
                height: 75.0,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: index + 100,
                    child: Image(
                      image: orderArray[index].images.length != 0
                          ? AdvImageCache(
                              LoadingScreenServices.imagePrefixUrl +
                                  orderArray[index]
                                      .images[0]
                                      .imageFileName
                                      .toString(),
                              useMemCache: true,
                              diskCacheExpire: Duration(days: 400),
                            )
                          : AssetImage("assets/kmIcon.png"),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              //SizedBox(width: 10),
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
                            Text(
                              orderArray[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18),
                            ),
                            SizedBox(height: 6),
                            Text(
                              orderArray[index].quantity.toString() +
                                  " " +
                                  orderArray[index].unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: UtilsImporter().colorUtils.greyColor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Text(
                                "${UtilsImporter().stringUtils.oCcy.format(int.parse(orderArray[index].price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        UtilsImporter().colorUtils.primaryColor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 4),
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
}
