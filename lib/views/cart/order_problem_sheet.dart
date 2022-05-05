import 'package:flutter/material.dart';
import 'package:kammun_app/models/products_categories_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/widget/kammun_button.dart';

class OrderProblemBottomSheet extends StatefulWidget {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final Function applyChanges;
  const OrderProblemBottomSheet(
      {Key key,
      @required this.notActiveProducts,
      @required this.pricesChangesProducts,
      @required this.applyChanges})
      : super(key: key);
  @override
  _OrderProblemBottomSheetState createState() => _OrderProblemBottomSheetState();
}

class _OrderProblemBottomSheetState extends State<OrderProblemBottomSheet> {
  List<ProductData> orderArray;
  List<int> notActiveCards = [];
  List<int> priceCards = [];

  bool loadingScreen = false;
  bool errorCode = false;

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

    if (priceCards.isNotEmpty && notActiveCards.isEmpty) {
      dialogText =
          "نأسف لحدوث ذلك ولكن أثناء قيامك بالتسوق تغير سعر  ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك مشاهدة تلك المنتجات و القيام بتحديث الطلب ليتم تحديث الأسعار او اختيار بدائل ";
    }
    if (notActiveCards.isNotEmpty && priceCards.isEmpty) {
      dialogText =
          "نأسف لحدوث ذلك و لكن أثناء قيامك بالتسوق نفذ ${notActiveCards.length} من المنتجات التي قمت بإضافتها يمكنك تحديث الطلب لحذف هذه المنتجات او اختيار بدائل عنها من داخل التطبيق";
    }
    if (notActiveCards.isNotEmpty && priceCards.isNotEmpty) {
      dialogText =
          "نأسف لحدوث ذلك ولكن أثناء قيامك بعملية التسوق نفذ ${notActiveCards.length} من المنتجات و تغير سعر ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك إختيار تحديث الطلب لمشاهدة الأسعار الجديدة و حذف المنتجات الغير متوفرة أو الضغط على إختيار بدائل لإضافتها من داخل التطبيق";
    }
  }

  void showUpdateDialog({title, body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "حدث خطأ بالطلب",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: Text(
            dialogText,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "إغلاق",
                style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    makeCards();

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog())
        : Tools.logToConsole('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                widget.notActiveProducts.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorUtils.primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            )),
                        child: Center(
                            child: Text(
                          "منتجات نفذت أثناء التسوق",
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontFamily: StringUtils.fontFamilyHKGrotesk),
                        )),
                      )
                    : Container(),
                widget.notActiveProducts.isNotEmpty
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 5, color: ColorUtils.kmColors)),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: orderArray == null ? 0 : notActiveCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                  child: cardBodyNotActive(notActiveCards[index], context),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                widget.notActiveProducts.isNotEmpty ? const SizedBox(height: 10) : Container(),
                widget.pricesChangesProducts.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorUtils.kmColors,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            )),
                        child: Center(
                            child: Text(
                          "منتجات تغير سعرها أثناء التسوق",
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontFamily: StringUtils.fontFamilyHKGrotesk),
                        )),
                      )
                    : Container(),
                widget.pricesChangesProducts.isNotEmpty
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 5, color: ColorUtils.primaryColor)),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: orderArray == null ? 0 : priceCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                  child: cardBodyPriceProblem(priceCards[index], context),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SafeArea(
                    child: Center(
                      child: Wrap(
                        spacing: 5,
                        children: [
                          KammunButton(
                            color: Colors.green,
                            onTap: () {
                              widget.applyChanges();
                            },
                            text: "تحديث الطلب",
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.3,
                          ),
                          KammunButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              KammunRestart.restartApp(context);
                            },
                            text: "محاولة إيجاد بدائل",
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    top: false,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget cardBodyNotActive(int index, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 75.0,
              height: 75.0,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: index + 100,
                  child: FadeInImage(
                    image: orderArray[index].images.isNotEmpty
                        ? NetworkImage(LoadingScreenServices.imagePrefixUrl +
                            orderArray[index].images[0].imageFileName.toString())
                        : const AssetImage("assets/kmIcon.png"),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    fadeInCurve: Curves.fastOutSlowIn,
                    placeholder: const AssetImage("assets/kmIcon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            //SizedBox(width: 10),
            const SizedBox(width: 10),
            Expanded(
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          orderArray[index].quantity.toString() + " " + orderArray[index].unit.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.greyColor,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 3,
        )
      ],
    );
  }

  Widget cardBodyPriceProblem(int index, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 75.0,
              height: 75.0,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: index + 100,
                  child: FadeInImage(
                    image: orderArray[index].images.isNotEmpty
                        ? NetworkImage(LoadingScreenServices.imagePrefixUrl +
                            orderArray[index].images[0].imageFileName.toString())
                        : const AssetImage("assets/kmIcon.png"),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    fadeInCurve: Curves.fastOutSlowIn,
                    placeholder: const AssetImage("assets/kmIcon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          orderArray[index].quantity.toString() + " " + orderArray[index].unit.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.greyColor,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${StringUtils().oCcy.format(int.parse(orderArray[index].price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.primaryColor,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 3,
        )
      ],
    );
  }
}
