import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

class ProductSubWarehouseInfoWidget extends StatefulWidget {
  final ProductEntity product;
  final Function(String) onChangePrice;
  final Function(String) onChangePriceFactor;
  const ProductSubWarehouseInfoWidget({Key key, this.product, this.onChangePrice, this.onChangePriceFactor})
      : super(key: key);

  @override
  State<ProductSubWarehouseInfoWidget> createState() => _ProductSubWarehouseInfoWidgetState();
}

class _ProductSubWarehouseInfoWidgetState extends State<ProductSubWarehouseInfoWidget> {
  @override
  Widget build(BuildContext context) {
    String price = widget.product.price;
    if (Services.hasRole(context, supplierRole)) {
      price = (int.parse(widget.product.price.split('.')[0]) - widget.product.increasePercentage).toString();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: UpdateProductInfoWidget(
            title: priceString + ' :',
            inputType: TextInputType.text,
            bodyKey: 'price',
            productId: widget.product.productId,
            productData: widget.product,
            textHint: price,
            increasePercentage: widget.product.increasePercentage,
            priceFactor: widget.product.priceFactor != null ? double.parse(widget.product.priceFactor) : 1,
            initialText: price,
            onSavePressed: (newValue, result) {
              if (result) {
                widget.product.price = newValue;
                price = newValue;
                widget.onChangePrice(newValue);
              }
            },
          ),
        ),
        UpdateProductInfoWidget(
          title: supplierCodeString + ':',
          inputType: TextInputType.text,
          textHint: widget.product.supplierCode,
          initialText: widget.product.supplierCode,
          bodyKey: 'supplier_code',
          productId: widget.product.productId,
          productData: widget.product,
          onSavePressed: (newValue, result) => widget.product.supplierCode = newValue,
        ),
        UpdateProductInfoWidget(
          title: priceFactorString + ' :',
          inputType: TextInputType.text,
          bodyKey: 'price_factor',
          productId: widget.product.productId,
          productData: widget.product,
          textHint: widget.product.priceFactor,
          initialText: widget.product.priceFactor,
          onSavePressed: (newValue, result) {
            if (result) {
              widget.product.priceFactor = newValue;
              price = newValue;
              widget.onChangePriceFactor(newValue);
            }
          },
        ),
      ],
    );
  }
}
