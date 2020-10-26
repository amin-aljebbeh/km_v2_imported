import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

class OrderProblemBottomSheet extends StatefulWidget {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final Function applyChanges;
  OrderProblemBottomSheet(
      {@required this.notActiveProducts,
      @required this.pricesChangesProducts,
      @required this.applyChanges});
  @override
  _OrderProblemBottomSheetState createState() =>
      _OrderProblemBottomSheetState();
}

class _OrderProblemBottomSheetState extends State<OrderProblemBottomSheet> {
  List<ProductsData> orderArray;
  List<int> notActivecards = [];
  List<int> priceCards = [];

  bool loadingScreen = false;
  bool errorCode = false;
  List<ProductsData> notActive;
  List<ProductsData> priceChanged;

  makeCards() {
    priceCards = [];
    notActivecards = [];

    for (int i = 0; i < orderArray.length; i++) {
      if (widget.notActiveProducts.contains(orderArray[i].id)) {
        notActivecards.add(i);
      }
      if (widget.pricesChangesProducts.contains(orderArray[i].id)) {
        priceCards.add(i);
      }
    }
  }

  Widget _okButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: AutoSizeText(
            "موافق",
            maxLines: 1,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
        child: loginButtonWithGesture);
  }

  void showUpdateDialog() {
    setState(() {
      loadingScreen = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1.0),
              topRight: Radius.circular(1.0),
              bottomLeft: Radius.circular(2.0),
              bottomRight: Radius.circular(2.0),
            ),
          ),
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
          titlePadding: EdgeInsets.all(0),
          title: Container(
            width: double.infinity,
            height: 50,
            color: Color.fromARGB(255, 247, 247, 247),
            child: Align(
              child: Padding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        "خطأ في الأسعار",
                        style: TextStyle(
                            fontSize: 17,
                            color: UtilsImporter().colorUtils.primarycolor,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
                padding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          content: Container(
            height: 330,
            child: Column(
              children: <Widget>[
                AutoSizeText(
                    "نأسف لحدوث ذلك و لكن خلال الوقت الذي كنت تقوم به بالتسوق قام مدير النظام بتخفيض أو زيادة سعر واحد أو اكثر من المنتجات التي قمت بإضافتها لسلة مشترياتك بإمكانك تحميل الأسعار الجديدة و مراجعتها قبل إتمام الطلب أو إلغاء عملية الشراء ",
                    maxLines: 9,
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk)),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Divider(
                  color: Colors.grey[600],
                ),

                _okButton(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Container(
                //       width: MediaQuery.of(context).size.width / 2.8,
                //       child: _updateButton(),
                //     ),
                //     Container(
                //       width: MediaQuery.of(context).size.width / 2.8,
                //       child: _cancelButton(ctx: context),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    makeCards();

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _userNotesInitial())
        : {};

    super.initState();
  }

  _userNotesInitial() {
    // Show PopUp Description
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
                            color: UtilsImporter().colorUtils.primarycolor,
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
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
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
                                orderArray == null ? 0 : notActivecards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _onTileClicked(index),
                                child: Container(
                                  //  color: Theme.of(context).primaryColorLight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child: cardBodyNotActive(index, context),
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
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
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
                                      UtilsImporter().colorUtils.primarycolor)),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                orderArray == null ? 0 : priceCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _onTileClicked(index),
                                child: Container(
                                  //  color: Theme.of(context).primaryColorLight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child: cardBodyPriceProblem(index, context),
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
                        _applyChanges(),
                        _showEditOrder(),
                      ],
                    ),
                  ),
                  top: false,
                ),
              ],
            ),
          ),
        ));
  }

  Widget cardBodyNotActive(int index, BuildContext context) {
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
                        child: FadeInImage(
                            image: orderArray[index].images.length != 0
                                ? NetworkImage(
                                    LoadingScreenServices.imagePrefixUrl +
                                        orderArray[index]
                                            .images[0]
                                            .imageFileName
                                            .toString())
                                : AssetImage("assets/kmIcon.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: AssetImage("assets/kmIcon.png"),
                            fit: BoxFit.contain))),
              ),
              //SizedBox(width: 10),
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
                                  color: UtilsImporter().colorUtils.greycolor,
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
                        child: FadeInImage(
                            image: orderArray[index].images.length != 0
                                ? NetworkImage(
                                    LoadingScreenServices.imagePrefixUrl +
                                        orderArray[index]
                                            .images[0]
                                            .imageFileName
                                            .toString())
                                : AssetImage("assets/kmIcon.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: AssetImage("assets/kmIcon.png"),
                            fit: BoxFit.contain))),
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
    debugPrint("You tapped on item $index");
    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) =>
    //             new ProductDetailView(heroIndex: index + 100)));
  }

  Widget _applyChanges() {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: widget.applyChanges,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width / 2.3,
          decoration: new BoxDecoration(
              color: Colors.green,
              borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: new Center(
            child: new AutoSizeText(
              "تحديث الطلب",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              maxLines: 2,
              wrapWords: false,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showConfirmButtonWithGesture);
  }

  Widget _showEditOrder() {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        KammunRestart.restartApp(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width / 2.3,
          decoration: new BoxDecoration(
              color: UtilsImporter().colorUtils.primarycolor,
              borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: new Center(
            child: new AutoSizeText(
              "محاولة إيجاد بدائل",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              maxLines: 2,
              wrapWords: false,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showConfirmButtonWithGesture);
  }
}
