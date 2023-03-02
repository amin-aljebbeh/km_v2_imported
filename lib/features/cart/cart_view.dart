import 'package:kammun_app/features/order_details/services/order_details_services.dart';
import 'package:kammun_app/features/orders/services/order_services.dart';

import '../../core/core_importer.dart';
import 'services/cart_services.dart';

class CartView extends StatefulWidget {
  static const String routeName = '/CartView';
  static const String fromUpdateRouteName = '/cartFromUpdate';
  final bool isFromUpdateOrder;

  const CartView({Key key, this.isFromUpdateOrder = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartViewState();
}

class CartViewState extends State<CartView> {
  List<ProductData> orderArray;
  int subtotal = 0;
  int deliveryCost = 10;
  static List<int> cards = [];
  int indexToEdit = -1;

  _cartChanged() async {
    String productsId = '';
    String productsQuantity = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    productsId = CartServices.cartProducts.fold('', (ids, product) => ids + product.id.toString() + ';');
    productsQuantity =
        CartServices.cartProducts.fold('', (counts, product) => counts + product.productCount.toString() + ';');
    prefs.setString('userCart', productsId + '@' + productsQuantity);
  }

  _calculateTotal() {
    subtotal = 0;

    setState(() => subtotal =
        orderArray.fold(0, (sum, order) => sum + ((int.parse(order.price.split('.')[0])) * order.productCount)));
  }

  @override
  void initState() {
    super.initState();
    orderArray = CartServices.cartProducts;

    if (StaticVariables.subWarehouses.length == 1) {
      orderArray.sort((a, b) {
        if (a.subWarehouseId > b.subWarehouseId) {
          return -1;
        } else if (a.subWarehouseId < b.subWarehouseId) {
          return 1;
        } else {
          return 0;
        }
      });
    } else {
      orderArray.sort((a, b) {
        if (a.subWarehouseId > b.subWarehouseId) {
          return 1;
        } else if (a.subWarehouseId < b.subWarehouseId) {
          return -1;
        } else {
          return 0;
        }
      });
    }
    cards = List<int>.generate(orderArray.length, (i) => i + 1);
    _calculateTotal();
  }

  void onrRemove(item) => setState(() => cards.removeAt(item));

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(shoppingCart, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 30)),
              ),
              CartServices.cartProducts.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.3),
                      child: const Center(child: ScreenMessage(message: 'سلة المشتريات فارغة')))
                  : Container(padding: EdgeInsets.zero),
              Expanded(
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: orderArray == null ? 0 : cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0, top: 0), child: cardBody(index, context)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(subtotalString, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 19.0)),
                  Text(
                    '${StringUtils().oCcy.format(subtotal)} ${StaticVariables.companyInformation.currency}',
                    style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 19),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SafeArea(
                child: KammunButton(
                  width: MediaQuery.of(context).size.width,
                  color: CartServices.cartProducts.isNotEmpty ? primaryColor : Colors.grey[400],
                  text: confirmOrder.toUpperCase(),
                  onTap: _showConfirmOrderBtnTapped,
                  height: 50,
                ),
                top: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _priceController = TextEditingController();

  //TODO: make widget
  Widget cardBody(int index, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            KCacheImage(
              tag: index + 100,
              image: orderArray[index].images.isNotEmpty
                  ? StaticVariables.imagePrefixUrl + orderArray[index].images[0].imageFileName
                  : '',
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
                        Text(orderArray[index].name,
                            style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text(orderArray[index].quantity.toString() + ' ' + orderArray[index].unit.toString(),
                            style: mainStyle.copyWith(fontWeight: FontWeight.w400, color: greyColor, fontSize: 17)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            indexToEdit == index
                                ? Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: TextFormField(
                                        controller: _priceController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: 'السعر الجديد',
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: const BorderSide())),
                                      ),
                                    ),
                                  )
                                : Text(
                                    '${StringUtils().oCcy.format(int.parse(orderArray[index].price.split('.')[0]))} ${StaticVariables.companyInformation.currency}',
                                    style: mainStyle.copyWith(
                                        fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                            indexToEdit == index
                                ? IconButton(
                                    icon: const Icon(Icons.save_rounded),
                                    color: Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        indexToEdit = -1;
                                        double priceFactor = double.parse(orderArray[index].quantity) /
                                            double.parse(orderArray[index].price);
                                        if (_priceController.text.isNotEmpty) {
                                          orderArray[index].price = _priceController.text.split('.')[0];
                                          orderArray[index].quantity =
                                              (priceFactor * double.parse(_priceController.text)).toStringAsFixed(2);
                                          CartServices.cartProducts = orderArray;
                                          OrderDetailsServices.updateOrder(
                                              orderId: OrderServices.orderUnderUpdateId,
                                              context: context,
                                              updateKey: 'product_quantity',
                                              updateValue: (priceFactor * double.parse(_priceController.text))
                                                  .toStringAsFixed(2),
                                              productId: orderArray[index].id.toString());
                                        }
                                      });
                                      _priceController.text = '';
                                      _calculateTotal();
                                    },
                                    iconSize: 30)
                                : IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.green,
                                    onPressed: () {
                                      setState(() => indexToEdit = index);
                                      _calculateTotal();
                                    },
                                    iconSize: 30),
                          ],
                        ),
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: greyColor.withOpacity(0.2)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        orderArray[index].productCount += 1;
                        subtotal += (int.parse(orderArray[index].price.split('.')[0]));
                      });
                      _cartChanged();
                    },
                    child: Image.asset('assets/add.png', width: 60, height: 60),
                  ),
                ),
                const SizedBox(height: 5),
                Text(orderArray[index].productCount.toString(),
                    style: mainStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
                const SizedBox(height: 5),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: greyColor.withOpacity(0.2)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (orderArray[index].productCount > 1) {
                          subtotal -= (int.parse(orderArray[index].price.split('.')[0]));
                          orderArray[index].productCount = orderArray[index].productCount - 1;
                        } else if (orderArray[index].productCount == 1) {
                          subtotal -= (int.parse(orderArray[index].price.split('.')[0]));
                          onrRemove(index);
                          CartServices.cartProducts.removeAt(index);
                        }
                      });
                      _cartChanged();
                    },
                    child: orderArray[index].productCount > 1
                        ? Image.asset('assets/remove.png', width: 60, height: 60)
                        : const Icon(Icons.delete_forever, size: 30, color: Colors.red),
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

  void _showConfirmOrderBtnTapped() {
    if (CartServices.cartProducts.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartViewFinal()))
          .then((onValue) => _calculateTotal());
    } else {
      Toast.show('يرجى إضافة منتج واحد على الأقل', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }
}
