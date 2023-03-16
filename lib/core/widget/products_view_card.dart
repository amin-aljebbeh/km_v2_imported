import 'package:kammun_app/features/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/features/products_view/barcode_screen.dart';

import '../../core/core_importer.dart';

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
    String price = widget.product.price;
    if (Services.isSupplierManager()) {
      price = (int.parse(widget.product.price.split('.')[0]) - widget.product.increasePercentage).toString();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(
              product: widget.product,
              onChangeSubWarehouse: (id) {
                setState(() {
                  widget.product.subWarehouseId = int.parse(id);
                  widget.onChangeSubWarehouse(id);
                });
              },
              onAddBarcode: (result) => widget.onAddBarcode(result),
              onChangePrice: (newValue) =>
                  setState(() => {widget.product.price = newValue, widget.onChangePrice(newValue)}),
              onChangeUnit: (newValue) =>
                  setState(() => {widget.product.unit = newValue, widget.onChangeUnit(newValue)}),
              onChangeQuantity: (newValue) =>
                  setState(() => {widget.product.quantity = newValue, widget.onChangeQuantity(newValue)}),
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
              KCacheImage(
                tag: widget.index + 100,
                image: widget.product.images.isNotEmpty
                    ? StaticVariables.imagePrefixUrl + widget.product.images[0].imageFileName
                    : '',
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.product.name, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              widget.product.unit != 'null'
                                  ? widget.product.quantity + ' ' + widget.product.unit
                                  : widget.product.quantity,
                              style: mainStyle.copyWith(fontWeight: FontWeight.w400, color: primaryColor, fontSize: 17),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                StringUtils().oCcy.format(int.parse(price.split('.')[0])).toString() +
                                    ' ${StaticVariables.companyInformation.currency}',
                                style:
                                    mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                          ],
                        ),
                        if (Services.isProductsController())
                          Row(
                            children: [
                              if (widget.product.barcodes.isEmpty) const Icon(KIcons.exclamation),
                              BarcodeIcon(
                                product: widget.product,
                                requestType: BarcodeRequestType.addBarcode,
                                productId: int.parse(widget.product.id.toString()),
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
              widget.product.subWarehouseId != -1
                  ? Column(
                      children: [
                        if (StaticVariables.subWarehouses.any((element) => element.id == widget.product.subWarehouseId))
                          SwitchProductStatusWidget(
                            isForSubWarehouse: true,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.17,
                            preState: int.parse(widget.product.isActive),
                            subWarehouseId: widget.product.subWarehouseId,
                            productId: widget.product.id.toString(),
                            onChange: (int active, bool result) => setState(() {
                              if (result) widget.product.isActive = active.toString();
                            }),
                          ),
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Services.isAdmin() || Services.isViewPriceRateRoll()
                                ? Text(
                                    'التقييم: ' +
                                        (widget.product.rate != -1
                                            ? StringUtils().oCcy.format(widget.product.rate).toString()
                                            : '0'),
                                    style: mainStyle.copyWith(
                                        fontWeight: FontWeight.w700, color: primaryColor, fontSize: 13),
                                  )
                                : Container(),
                            const SizedBox(height: 5),
                            Services.isProductsController()
                                ? Text(
                                    'الكمية: ' +
                                        (widget.product.availableQuantity != 'null'
                                            ? StringUtils()
                                                .oCcy
                                                .format(int.parse(widget.product.availableQuantity.split('.')[0]))
                                                .toString()
                                            : ' '),
                                    style: mainStyle.copyWith(
                                        fontWeight: FontWeight.w700, color: primaryColor, fontSize: 13),
                                  )
                                : Container(),
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
                          if (widget.product.barcodes.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (screenContext) => BarCodeScreen(
                                  product: widget.product,
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
                                                AddProductsToSubWarehouse(barcode: param, product: widget.product)));
                                  },
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                                widget.scaffoldKey.currentContext,
                                MaterialPageRoute(
                                    builder: (context) => AddProductsToSubWarehouse(product: widget.product)));
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
