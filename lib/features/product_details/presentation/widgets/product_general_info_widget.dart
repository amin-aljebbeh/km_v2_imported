import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

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
            productId: product.productId,
            productData: product,
            initialText: product.increasePercentage.toString(),
            onSavePressed: (newValue, result) => product.increasePercentage = int.parse(newValue),
          ),
        UpdateProductInfoWidget(
          title: priority + ' :',
          textHint: product.priority.toString(),
          inputType: TextInputType.text,
          bodyKey: 'priority',
          productId: product.productId,
          productData: product,
          initialText: product.priority.toString(),
          onSavePressed: (newValue, result) => product.priority = int.parse(newValue),
        ),
        UpdateProductInfoWidget(
          title: nameString,
          textHint: product.name,
          inputType: TextInputType.multiline,
          bodyKey: 'name',
          productId: product.productId,
          initialText: product.name,
          isForSubWarehouse: false,
          productData: product,
          onSavePressed: (newValue, result) => product.name = newValue,
        ),
        UpdateProductInfoWidget(
          title: unitString + ' :',
          inputType: TextInputType.multiline,
          bodyKey: 'unit',
          productId: product.productId,
          isForSubWarehouse: false,
          productData: product,
          textHint: product.unit,
          initialText: product.unit,
          onSavePressed: (newValue, result) => {product.unit = newValue, onChangeUnit(newValue)},
        ),
        UpdateProductInfoWidget(
          title: quantityString + ' :',
          isForSubWarehouse: false,
          inputType: TextInputType.text,
          productData: product,
          textHint: product.quantity,
          bodyKey: 'quantity',
          productId: product.productId,
          initialText: product.quantity,
          onSavePressed: (newValue, result) => {product.quantity = newValue, onChangeQuantity(newValue)},
        ),
        UpdateProductInfoWidget(
          title: descriptionString + ' :',
          textHint: 'الوصف الجديد',
          inputType: TextInputType.multiline,
          bodyKey: 'description',
          productId: product.productId,
          isForSubWarehouse: false,
          productData: product,
          initialText: product.description,
          onSavePressed: (newValue, result) => product.description = newValue,
        ),
      ],
    );
  }
}
