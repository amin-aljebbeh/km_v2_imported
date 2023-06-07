import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../core/core_importer.dart';

class ProductGeneralInfoWidget extends StatelessWidget {
  final ProductEntity product;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;
  const ProductGeneralInfoWidget({Key key, this.product, this.onChangeUnit, this.onChangeQuantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Services.hasPermission(context, updateIncreasePercentagePermission))
          UpdateProductInfoWidget(
            title: 'نسبة الزيادة:',
            textHint: product.increasePercentage.toString(),
            inputType: TextInputType.text,
            bodyKey: 'increase_percentage',
            productId: product.id,
            productData: product,
            initialText: product.increasePercentage.toString(),
            onSavePressed: (newValue, result) => product.increasePercentage = int.parse(newValue),
          ),
        UpdateProductInfoWidget(
          title: edit + ' ' + priority + ' :',
          textHint: product.priority.toString(),
          inputType: TextInputType.text,
          bodyKey: 'priority',
          productId: product.id,
          productData: product,
          initialText: product.priority.toString(),
          onSavePressed: (newValue, result) => product.priority = int.parse(newValue),
        ),
        UpdateProductInfoWidget(
          title: edit + ' ' + nameString,
          textHint: product.name,
          inputType: TextInputType.multiline,
          bodyKey: 'name',
          productId: product.id,
          initialText: product.name,
          isForSubWarehouse: false,
          productData: product,
          onSavePressed: (newValue, result) => product.name = newValue,
        ),
        UpdateProductInfoWidget(
          title: edit + ' ' + unitString + ' :',
          inputType: TextInputType.multiline,
          bodyKey: 'unit',
          productId: product.id,
          isForSubWarehouse: false,
          productData: product,
          textHint: product.unit,
          initialText: product.unit,
          onSavePressed: (newValue, result) => {product.unit = newValue, onChangeUnit(newValue)},
        ),
        UpdateProductInfoWidget(
          title: edit + ' ' + quantityString + ' :',
          isForSubWarehouse: false,
          inputType: TextInputType.text,
          productData: product,
          textHint: product.quantity,
          bodyKey: 'quantity',
          productId: product.id,
          initialText: product.quantity,
          onSavePressed: (newValue, result) => {product.quantity = newValue, onChangeQuantity(newValue)},
        ),
        UpdateProductInfoWidget(
          title: edit + ' ' + descriptionString + ' :',
          textHint: 'الوصف الجديد',
          inputType: TextInputType.multiline,
          bodyKey: 'description',
          productId: product.id,
          isForSubWarehouse: false,
          productData: product,
          initialText: product.description,
          onSavePressed: (newValue, result) => product.description = newValue,
        ),
      ],
    );
  }
}
