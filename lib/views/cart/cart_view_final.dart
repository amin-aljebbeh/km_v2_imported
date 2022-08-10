import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../core/core_importer.dart';
import '../orders/model/submit_order_model.dart';
import 'order_problem_sheet.dart';

class CartViewFinal extends StatefulWidget {
  static String message = '';

  const CartViewFinal({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartViewFinalState();
}

class _CartViewFinalState extends State<CartViewFinal> {
  List<ProductData> orderArray;
  int subtotal = 0;
  List<int> cards = [];
  bool loadingScreen = false;
  bool errorCode = false;
  String errorMessage = 'يرجى المحاولة مرة أخرى و التأكد من إتصالك بالإنترنت';

  int total = 0;
  final TextEditingController _userNotes = TextEditingController();

  _reloadPrices() async {
    Navigator.of(context).pop();

    setState(() => loadingScreen = true);

    CartServices.cartProducts.clear();
    await CartServices.getUserCart();
    setState(() => loadingScreen = false);
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/cartFinal');
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    cards = List<int>.generate(orderArray.length, (i) => i + 1);

    subtotal = orderArray.fold(0, (sum, order) => sum + (int.parse(order.price.split('.')[0]) * order.productCount));
    total = subtotal + Services.deliveryPrice;

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) => _userNotesInitial())
        : {};

    super.initState();
  }

  void onrRemove(item) {
    setState(() {
      cards.removeAt(item);
      CartViewState.cards.removeAt(item);

      if (cards.isEmpty) KammunRestart.restartApp(context);
    });
  }

  _userNotesInitial() => _userNotes.text = OrderServices.updateOrderNote;

  _cartChanged() async {
    String productsId = '';
    String productsQuantity = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    productsId = CartServices.cartProducts.fold('', (ids, product) => ids + product.id.toString() + ';');
    productsQuantity =
        CartServices.cartProducts.fold('', (counts, product) => counts + product.productCount.toString() + ';');
    prefs.setString('userCart', productsId + '@' + productsQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
        child: SafeArea(
          child: loadingScreen
              ? const Center(child: Loader())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    errorCode
                        ? AlertMessages(
                            text: ' $errorMessage',
                            messageType: 'internetError',
                            headerText: ' حدث خطأ اثناء محاولة إرسال طلبك')
                        : Container(padding: EdgeInsets.zero),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                              onPressed: () => Navigator.of(context).pop('updatePrice'),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop('updatePrice'),
                            child: Text(
                              StringUtils.shoppingCart,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: orderArray == null ? 0 : cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => {},
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                              child: cardBody(index, context),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          StringUtils.subtotal,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          '${StringUtils().oCcy.format(subtotal)} ${LoadingScreenServices.companyInformation.currency}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 17.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
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
                          '${StringUtils().oCcy.format(Services.deliveryPrice)} ${LoadingScreenServices.companyInformation.currency}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
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
                          '${StringUtils().oCcy.format(total)} ${LoadingScreenServices.companyInformation.currency}',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 19),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SafeArea(
                      child: loadingScreen
                          ? const Loader()
                          : Column(
                              children: <Widget>[
                                KammunButton(
                                  color: ColorUtils.primaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 15),
                                        child: const Icon(Icons.add_box_outlined, color: Colors.white, size: 32),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'إضافة ملاحظة',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: StringUtils.fontFamilyHKGrotesk),
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.add, color: Colors.transparent, size: 32),
                                    ],
                                  ),
                                  onTap: () {
                                    showMyDialog(
                                      title: 'إضافة ملاحظة',
                                      dialogButtons: [],
                                      content: Stack(
                                        clipBehavior: Clip.none,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            top: -40.0,
                                            child: InkResponse(
                                                onTap: () => Navigator.of(context).pop(),
                                                child: const CircleAvatar(
                                                    child: Icon(Icons.close), backgroundColor: Colors.red)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'ملاحظات على الطلب',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 8, right: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                    border: Border.all(width: 2, color: ColorUtils.kmColors)),
                                                child: TextField(
                                                  controller: _userNotes,
                                                  textAlign: TextAlign.right,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: 5,
                                                  style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
                                                ),
                                              ),
                                              KammunButton(
                                                text: StringUtils.save + ' ' + StringUtils.note,
                                                width: MediaQuery.of(context).size.width / 2.5,
                                                height: 40,
                                                color: ColorUtils.primaryColor,
                                                onTap: () => Navigator.of(context).pop(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                KammunButton(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      CartServices.cartProducts.isNotEmpty ? ColorUtils.primaryColor : Colors.grey[400],
                                  text: StringUtils.confirmOrder,
                                  onTap: () {
                                    _cartChanged();
                                    _showConfirmOrderBtnTapped();
                                  },
                                  height: 50,
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),
                      top: false,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget cardBody(int index, BuildContext context) {
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
                            LoadingScreenServices.imagePrefixUrl + orderArray[index].images[0].imageFileName.toString(),
                            useMemCache: true,
                            diskCacheExpire: const Duration(days: 400),
                          )
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
                        Text(
                          orderArray[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          orderArray[index].quantity.toString() + ' ' + orderArray[index].unit.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.greyColor,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 17),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            '${StringUtils().oCcy.format(int.parse(orderArray[index].price.split('.')[0]))} ${LoadingScreenServices.companyInformation.currency}',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.primaryColor,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorUtils.greyColor.withOpacity(0.2)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        orderArray[index].productCount += 1;
                        subtotal += (int.parse(orderArray[index].price.split('.')[0]));

                        total += (int.parse(orderArray[index].price.split('.')[0]));
                      });
                      _cartChanged();
                    },
                    child: Image.asset('assets/add.png', width: 60, height: 60),
                  ),
                ),
                const SizedBox(height: 5),
                Text(orderArray[index].productCount.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 18)),
                const SizedBox(height: 5),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorUtils.greyColor.withOpacity(0.2)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (orderArray[index].productCount > 1) {
                          subtotal -= (int.parse(orderArray[index].price.split('.')[0]));
                          orderArray[index].productCount = orderArray[index].productCount - 1;

                          total -= (int.parse(orderArray[index].price.split('.')[0]));
                        } else if (orderArray[index].productCount == 1) {
                          subtotal -= (int.parse(orderArray[index].price.split('.')[0]));

                          total -= (int.parse(orderArray[index].price.split('.')[0]));
                          onrRemove(index);
                          CartServices.cartProducts.removeAt(index);
                        }
                      });
                      _cartChanged();
                    },
                    child: Image.asset('assets/remove.png', width: 60, height: 60),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(thickness: 3)
      ],
    );
  }

  _showBottomSheet({List<String> notActive, List<String> priceProblem}) {
    List<int> notActiveId = [];
    List<int> priceId = [];

    notActiveId =
        orderArray.where((order) => notActive.contains(order.id.toString())).toList().map((order) => order.id).toList();
    priceId = orderArray
        .where((order) => priceProblem.contains(order.id.toString()))
        .toList()
        .map((order) => order.id)
        .toList();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => OrderProblemBottomSheet(
        notActiveProducts: notActiveId,
        pricesChangesProducts: priceId,
        applyChanges: (submitOrder) {
          if (submitOrder) {
            _showConfirmOrderBtnTapped(checkOrderPrice: false);
          } else {
            _reloadPrices();
          }
        },
      ),
    );
  }

  void _showConfirmOrderBtnTapped({bool checkOrderPrice = true}) async {
    try {
      setState(() {
        loadingScreen = true;
        errorCode = false;
      });
      CartServices.userNote = _userNotes.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      OrderResponse orderResponse;

      if (OrderServices.orderUnderUpdateIndex != -1) {
        List<InvoiceProductModel> products = orderArray
            .map((product) => InvoiceProductModel(
                quantity: product.productCount, price: int.parse(product.price.split('.')[0]), productId: product.id))
            .toList();
        int purchasePrices = orderArray.fold(
            0, (value, product) => value + (product.productCount * int.parse(product.price.split('.')[0])));
        SubmitOrderModel submitOrderModel =
            SubmitOrderModel(products: products, purchasePrices: purchasePrices, userNote: _userNotes.text);
        orderResponse =
            await OrderServices.updateOrder(submitOrderModel: submitOrderModel, checkPrices: checkOrderPrice);

        setState(() {
          try {
            if (orderResponse != null) {
              if (!orderResponse.success && orderResponse.reason.contains('discontinued')) {
                loadingScreen = false;
                errorCode = true;
                errorMessage =
                    'نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل';
              } else if (orderResponse.changedPriceProducts.isNotEmpty || orderResponse.inactiveProducts.isNotEmpty) {
                _showBottomSheet(
                    notActive: orderResponse.inactiveProducts, priceProblem: orderResponse.changedPriceProducts);

                loadingScreen = false;
                errorCode = false;
              } else if (orderResponse.success) {
                CartViewFinal.message = orderResponse.data;
                prefs.setString('orderUnderUpdateId', '-1');
                OrderServices.orderUnderUpdateIndex = -1;
              } else if (!orderResponse.success) {
                loadingScreen = false;
                errorCode = true;
              }
            } else {
              loadingScreen = false;
              errorCode = true;
            }
          } catch (e) {
            loadingScreen = false;
            errorCode = true;
          }
        });
      }
      try {
        if (orderResponse.success == true) {
          await prefs.remove('userCart');
          CartServices.cartProducts.clear();

          CartServices.userNote = '';

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ThankYouView(orderMessage: orderResponse.message)));
        }
      } catch (e) {
        /**/
      }
    } catch (e) {
      /**/
    }
  }
}
