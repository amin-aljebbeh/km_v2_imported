import 'package:kammun_app/features/cart/services/cart_services.dart';
import 'package:kammun_app/features/orders/services/order_services.dart';

import '../../core/core_importer.dart';

class OrderProblemBottomSheet extends StatefulWidget {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final Function(bool updatePrice) applyChanges;

  const OrderProblemBottomSheet(
      {Key key, @required this.notActiveProducts, @required this.pricesChangesProducts, @required this.applyChanges})
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
          'نأسف لحدوث ذلك ولكن أثناء قيامك بالتسوق تغير سعر  ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك مشاهدة تلك المنتجات و القيام بتحديث الطلب ليتم تحديث الأسعار او اختيار بدائل ';
    }
    if (notActiveCards.isNotEmpty && priceCards.isEmpty) {
      dialogText =
          'نأسف لحدوث ذلك و لكن أثناء قيامك بالتسوق نفذ ${notActiveCards.length} من المنتجات التي قمت بإضافتها يمكنك تحديث الطلب لحذف هذه المنتجات او اختيار بدائل عنها من داخل التطبيق';
    }
    if (notActiveCards.isNotEmpty && priceCards.isNotEmpty) {
      dialogText =
          'نأسف لحدوث ذلك ولكن أثناء قيامك بعملية التسوق نفذ ${notActiveCards.length} من المنتجات و تغير سعر ${priceCards.length} من المنتجات التي قمت بإضافتها يمكنك إختيار تحديث الطلب لمشاهدة الأسعار الجديدة و حذف المنتجات الغير متوفرة أو الضغط على إختيار بدائل لإضافتها من داخل التطبيق';
    }
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    makeCards();

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            showMyDialog(
                context: context, title: 'حدث خطأ بالطلب', text: dialogText, dialogButtons: [const CloseWidget()]);
          })
        : {};

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
                          color: primaryColor,
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                      child: Center(
                          child: Text('منتجات نفذت أثناء التسوق',
                              style: mainStyle.copyWith(fontSize: 20, color: Colors.white))),
                    )
                  : Container(),
              widget.notActiveProducts.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 5, color: kmColors)),
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
                          color: kmColors,
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                      child: Center(
                          child: Text('منتجات تغير سعرها أثناء التسوق',
                              style: mainStyle.copyWith(fontSize: 20, color: Colors.white))),
                    )
                  : Container(),
              widget.pricesChangesProducts.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 5, color: primaryColor)),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: orderArray == null ? 0 : priceCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {},
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                  child: cardBodyPriceProblem(priceCards[index], context)),
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
                        text: 'تحديث الطلب',
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.3,
                        color: Colors.green,
                        onTap: () => widget.applyChanges(false),
                      ),
                      KammunButton(
                        text: '!! إرسال الطلب !!',
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.3,
                        color: Colors.red,
                        onTap: () {
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

  Widget cardBodyNotActive(int index, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            KCacheImage(
              tag: index + 100,
              image: StaticVariables.imagePrefixUrl + orderArray[index].images[0].imageFileName.toString(),
            ),
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
                          style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        Text(
                          orderArray[index].quantity.toString() + ' ' + orderArray[index].unit.toString(),
                          style: mainStyle.copyWith(fontWeight: FontWeight.w400, color: primaryColor, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(thickness: 3)
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
                  child: Image(
                    image: orderArray[index].images.isNotEmpty
                        ? AdvImageCache(
                            StaticVariables.imagePrefixUrl + orderArray[index].images[0].imageFileName.toString(),
                            useMemCache: true,
                            diskCacheExpire: const Duration(days: 400))
                        : const AssetImage('assets/kmIcon.png'),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
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
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(orderArray[index].name,
                            style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text(orderArray[index].quantity.toString() + ' ' + orderArray[index].unit.toString(),
                            style:
                                mainStyle.copyWith(fontWeight: FontWeight.w400, color: searchGreyColor, fontSize: 17)),
                        const SizedBox(height: 8),
                        Text(
                            '${StringUtils().oCcy.format(int.parse(orderArray[index].price.split('.')[0]))} ${StaticVariables.companyInformation.currency}',
                            style: mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // SizedBox(height: 4),
        const Divider(thickness: 3)
      ],
    );
  }
}
