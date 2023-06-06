import '../../../core/core_importer.dart';

class AddToCartWidget extends StatefulWidget {
  final ProductData product;
  const AddToCartWidget({Key key, this.product}) : super(key: key);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  int numberOfOrders = 1;
  @override
  Widget build(BuildContext context) {
    ProductData product = widget.product;
    String price = product.price;
    if (Services.hasRole(context, supplierRole)) {
      price = (int.parse(product.price.split('.')[0]) - product.increasePercentage).toString();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                  child: InkWell(
                      onTap: () => setState(() {
                            if (numberOfOrders > 1) numberOfOrders = numberOfOrders - 1;
                          }),
                      child: Image.asset('assets/remove.png', width: 60, height: 60))),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 0),
                child: Text(numberOfOrders.toString(),
                    style: mainStyle.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 35)),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                  child: InkWell(
                      onTap: () => setState(() => numberOfOrders = numberOfOrders + 1),
                      child: Image.asset('assets/add.png', width: 60, height: 60))),
            ],
          ),
        ),
        if (product.isActive == '0')
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: primaryColor, width: 4)),
              child: Center(
                  child: Text(outOfStock, style: mainStyle.copyWith(fontSize: 25, fontWeight: FontWeight.bold)))),
        KammunButton(
          text: '$addToCart  (${StringUtils().oCcy.format(numberOfOrders * int.parse(price.split('.')[0]))})',
          height: 50,
          color: Theme.of(context).primaryColor,
          onTap: () async {
            if (LoadingScreen.userToken.length > 5) {
              Navigator.of(context).pop(true);
              product.productCount = numberOfOrders;
              ProductData productData = product;
              productData.pivot = OrderProductPivot(increaseValue: product.increasePercentage);
              productData.price = price;
              //todo handle adding to cart
              snackBar(success: true, message: 'تم إضافة ${product.name} لسلة المشتريات', context: context);
            } else {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            }
          },
        ),
      ],
    );
  }
}
