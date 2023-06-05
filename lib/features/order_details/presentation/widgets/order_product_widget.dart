import 'package:kammun_app/features/order_details/presentation/pages/full_screen_image.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import 'product_sub_warehouse_widget.dart';

class OrderProductWidget extends StatelessWidget {
  final ProductEntity productData;
  final Function onCheckbox;
  final bool newSubWarehouse;

  const OrderProductWidget({Key key, this.productData, this.onCheckbox, this.newSubWarehouse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int purchasePrice = int.parse(productData.pivot.purchasePrice.split('.')[0]) - productData.pivot.increaseValue;
    double discountPercentage = SubWarehouse.getDiscountPercentage(productData.subWarehouseId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (newSubWarehouse)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            color: searchGreyColor,
            child: Center(
              child: Text(
                StaticVariables.subWarehouses
                    .firstWhere((subWarehouse) => subWarehouse.id == productData.pivot.subWarehouseId,
                        orElse: () => SubWarehouse(name: 'No element'))
                    .name,
                style: labelStyle,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 20,
          ),
        Row(
          children: <Widget>[
            if (!StaticVariables.preferLeftSide)
              ProductCheckWidget(product: productData, onCheckbox: () => onCheckbox()), //right side
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => FullScreenImage(
                          imageUrl: productData.images.isNotEmpty
                              ? StaticVariables.imagePrefixUrl + productData.images[0].imageFileName
                              : '',
                          tag: 'generate_a_unique_tag'))),
              child: KCacheImage(
                tag: int.parse(productData.pivot.productId),
                image: productData.images.isNotEmpty
                    ? StaticVariables.imagePrefixUrl + productData.images[0].imageFileName
                    : '',
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(productData.name, style: mainStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(productData.quantity + ' ' + (productData.unit ?? ''), style: darkBold),
                  Text(StringUtils().oCcy.format(purchasePrice) + ' ${StaticVariables.companyInformation.currency}',
                      style: paragraphStyle),
                  if (Services.hasRole(context, operationManagerRole) &&
                      purchasePrice - int.parse(productData.pivot.purchasePrice.split('.')[0]) != 0)
                    Text(
                        StringUtils().oCcy.format(int.parse(productData.pivot.purchasePrice.split('.')[0])) +
                            ' ${StaticVariables.companyInformation.currency}',
                        style: warningStyle),
                  if (Services.hasRole(context, supplierRole))
                    Text(
                      StringUtils().oCcy.format(purchasePrice - (purchasePrice * discountPercentage)) +
                          ' ${StaticVariables.companyInformation.currency}',
                      style: paragraphStyle,
                    ),
                  Text('كمية المستودع : ' + productData.availableQuantity, style: mainStyle.copyWith(color: kmColors)),
                  if ((!Services.hasRole(context, supplierRole)) &&
                      StaticVariables.subWarehouses
                          .where((subWarehouse) =>
                              subWarehouse.id == productData.subWarehouseId ||
                              subWarehouse.allowShopperAssign == '1' ||
                              Services.hasRole(context, operationManagerRole))
                          .isNotEmpty)
                    ProductSubWarehouse(product: productData),
                ],
              ),
            ),
            if (StaticVariables.preferLeftSide)
              ProductCheckWidget(product: productData, onCheckbox: () => onCheckbox()),
          ],
        ),
        const Divider()
      ],
    );
  }
}
