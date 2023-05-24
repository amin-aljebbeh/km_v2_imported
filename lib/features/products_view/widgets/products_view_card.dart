import 'package:kammun_app/features/product_detail_view/pages/product_detail_view.dart';
import 'package:kammun_app/features/products_view/pages/barcode_screen.dart';

import '../../../core/core_importer.dart';

class ProductsViewCard extends StatefulWidget {
  final int index;
  final ProductData product;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;
  final Function(String) onChangePrice;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;
  final Function(String) onChangeSubWarehouse;

  const ProductsViewCard({
    Key key,
    this.index,
    this.product,
    this.scaffoldKey,
    this.onAddBarcode,
    this.onChangePrice,
    this.onChangeUnit,
    this.onChangeQuantity,
    this.onChangeSubWarehouse,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductsViewCardState();
}

class ProductsViewCardState extends State<ProductsViewCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    String price = product.price;
    if (Services.hasRole(context, supplierRole)) {
      price = (int.parse(product.price.split('.')[0]) - product.increasePercentage).toString();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(
              product: product,
              onChangeSubWarehouse: (id) {
                product.subWarehouseId = int.parse(id);
                widget.onChangeSubWarehouse(id);
              },
              onAddBarcode: (result) => widget.onAddBarcode(result),
              onChangePrice: (newValue) => {product.price = newValue, widget.onChangePrice(newValue)},
              onChangeUnit: (newValue) => {product.unit = newValue, widget.onChangeUnit(newValue)},
              onChangeQuantity: (newValue) => {product.quantity = newValue, widget.onChangeQuantity(newValue)},
            ),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: KCacheImage(
                  tag: widget.index + 100,
                  image:
                      product.images.isNotEmpty ? StaticVariables.imagePrefixUrl + product.images[0].imageFileName : '',
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(product.name, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 8),
                              child: Text(
                                product.unit != 'null' ? product.quantity + ' ' + product.unit : product.quantity,
                                style:
                                    mainStyle.copyWith(fontWeight: FontWeight.w400, color: primaryColor, fontSize: 17),
                              ),
                            ),
                            Text(
                                StringUtils().oCcy.format(int.parse(price.split('.')[0])) +
                                    ' ${StaticVariables.companyInformation.currency}',
                                style:
                                    mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                          ],
                        ),
                        if (Services.hasRole(context, productsControllerRole))
                          Row(
                            children: [
                              if (product.barcodes.isEmpty) const Icon(KIcons.exclamation),
                              BarcodeIcon(
                                product: product,
                                requestType: BarcodeRequestType.addBarcode,
                                productId: int.parse(product.id.toString()),
                                scaffoldKey: widget.scaffoldKey,
                                onAddBarcode: (result) => widget.onAddBarcode(result),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              product.subWarehouseId != -1
                  ? Column(
                      children: [
                        if (StaticVariables.subWarehouses.any((element) => element.id == product.subWarehouseId))
                          SwitchProductStatusWidget(
                            isForSubWarehouse: true,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.17,
                            preState: int.parse(product.isActive),
                            subWarehouseId: product.subWarehouseId,
                            productId: product.id.toString(),
                            onChange: (int active, bool result) => setState(() {
                              if (result) product.isActive = active.toString();
                            }),
                          ),
                        if (Services.hasRole(context, productsControllerRole))
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  'التقييم: ' + (product.rate != -1 ? StringUtils().oCcy.format(product.rate) : '0'),
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w700, color: primaryColor, fontSize: 13),
                                ),
                              ),
                              Text(
                                'الكمية: ' +
                                    (product.availableQuantity != 'null'
                                        ? StringUtils().oCcy.format(int.parse(product.availableQuantity.split('.')[0]))
                                        : ' '),
                                style:
                                    mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 13),
                              ),
                            ],
                          ),
                      ],
                    )
                  : Container(
                      height: 58,
                      width: 69,
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: kmColors, width: 2)),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          if (product.barcodes.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (screenContext) => BarCodeScreen(
                                  product: product,
                                  requestType: BarcodeRequestType.attachProduct,
                                  onIgnore: (barcode) async {
                                    int param;
                                    if (barcode == null) {
                                      param = null;
                                    } else {
                                      param = int.parse(barcode);
                                    }
                                    Navigator.push(
                                        widget.scaffoldKey.currentContext,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddProductsToSubWarehouse(barcode: param, product: product)));
                                  },
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(widget.scaffoldKey.currentContext,
                                MaterialPageRoute(builder: (context) => AddProductsToSubWarehouse(product: product)));
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
