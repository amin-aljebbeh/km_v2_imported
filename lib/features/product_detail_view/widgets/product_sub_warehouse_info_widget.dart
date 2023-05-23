import '../../../core/core_importer.dart';

class ProductSubWarehouseInfoWidget extends StatelessWidget {
  final ProductData product;
  final Function(String) onChangePrice;
  const ProductSubWarehouseInfoWidget({Key key, this.product, this.onChangePrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price = product.price;
    if (Services.hasRole(context, supplierRole)) {
      price = (int.parse(product.price.split('.')[0]) - product.increasePercentage).toString();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: UpdateProductInfoWidget(
            title: edit + ' ' + priceString + ' :',
            inputType: TextInputType.text,
            bodyKey: 'price',
            productId: product.id,
            productData: product,
            textHint: price,
            increasePercentage: product.increasePercentage,
            priceFactor: product.priceFactor != null ? double.parse(product.priceFactor) : 1,
            initialText: price,
            onSavePressed: (newValue, result) {
              if (result) {
                product.price = newValue;
                price = newValue;
                onChangePrice(newValue);
              }
            },
          ),
        ),
        UpdateProductInfoWidget(
          title: edit + ' ' + supplierCodeString + ':',
          inputType: TextInputType.text,
          textHint: product.supplierCode,
          initialText: product.supplierCode,
          bodyKey: 'supplier_code',
          productId: product.id,
          productData: product,
          onSavePressed: (newValue, result) => product.supplierCode = newValue,
        ),
        UpdateProductInfoWidget(
          title: priceFactor + ' :',
          inputType: TextInputType.text,
          bodyKey: 'price_factor',
          productId: product.id,
          productData: product,
          textHint: product.priceFactor,
          initialText: product.priceFactor,
          onSavePressed: (newValue, result) => product.priceFactor = newValue,
        ),
      ],
    );
  }
}
