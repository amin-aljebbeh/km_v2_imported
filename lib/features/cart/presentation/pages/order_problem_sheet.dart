import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

class OrderProblemBottomSheet extends StatefulWidget {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final List<ProductEntity> cartProducts;
  final Function(bool updatePrice) applyChanges;

  const OrderProblemBottomSheet({
    Key key,
    @required this.notActiveProducts,
    @required this.pricesChangesProducts,
    @required this.applyChanges,
    this.cartProducts,
  }) : super(key: key);

  @override
  _OrderProblemBottomSheetState createState() => _OrderProblemBottomSheetState();
}

class _OrderProblemBottomSheetState extends State<OrderProblemBottomSheet> {
  List<int> notActiveCards = [];
  List<int> priceCards = [];

  bool loadingScreen = false;
  bool errorCode = false;

  String dialogText;

  makeCards() {
    priceCards = [];
    notActiveCards = [];

    for (int i = 0; i < widget.cartProducts.length; i++) {
      if (widget.notActiveProducts.contains(widget.cartProducts[i].id)) {
        notActiveCards.add(i);
      }
      if (widget.pricesChangesProducts.contains(widget.cartProducts[i].id)) {
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
    makeCards();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
        child: SafeArea(
          child: widget.cartProducts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.notActiveProducts.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                        child: Center(
                            child: Text('منتجات نفذت أثناء التسوق',
                                style: mainStyle.copyWith(fontSize: 20, color: Colors.white))),
                      ),
                    if (widget.notActiveProducts.isNotEmpty)
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 5, color: kmColors)),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: widget.cartProducts == null ? 0 : notActiveCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                child: cardBodyNotActive(notActiveCards[index], context),
                              );
                            },
                          ),
                        ),
                      ),
                    if (widget.pricesChangesProducts.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: kmColors,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                        child: Center(
                            child: Text('منتجات تغير سعرها أثناء التسوق',
                                style: mainStyle.copyWith(fontSize: 20, color: Colors.white))),
                      ),
                    if (widget.pricesChangesProducts.isNotEmpty)
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 5, color: primaryColor)),
                          margin: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: widget.cartProducts == null ? 0 : priceCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                  child: cardBodyPriceProblem(priceCards[index], context));
                            },
                          ),
                        ),
                      ),
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
                                widget.applyChanges(true);
                              },
                            ),
                          ],
                        ),
                      ),
                      top: false,
                    ),
                  ],
                )
              : Container(),
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: KCacheImage(tag: index + 100, image: widget.cartProducts[index].images[0].imageFileName),
            ),
            Expanded(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.cartProducts[index].name,
                            style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                        Text(
                          widget.cartProducts[index].quantity + ' ' + widget.cartProducts[index].unit,
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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
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
                  margin: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                      tag: index + 100,
                      child: Image(
                        image: widget.cartProducts[index].images.isNotEmpty
                            ? AdvImageCache(
                                state.generalInformationState.companyInformation.imagePrefixUrl +
                                    widget.cartProducts[index].images[0].imageFileName,
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
                Expanded(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.cartProducts[index].name,
                                style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 8),
                              child: Text(widget.cartProducts[index].quantity + ' ' + widget.cartProducts[index].unit,
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w400, color: searchGreyColor, fontSize: 17)),
                            ),
                            Text(
                                StringUtils().oCcy.format(int.parse(widget.cartProducts[index].price.split('.')[0])) +
                                    state.generalInformationState.companyInformation.currency,
                                style:
                                    mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
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
      },
    );
  }
}
