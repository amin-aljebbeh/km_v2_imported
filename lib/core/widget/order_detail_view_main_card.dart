import 'package:kammun_app/features/order_details/full_screen_image.dart';
import 'package:kammun_app/features/order_details/services/order_details_services.dart';

import '../../core/core_importer.dart';

class OrderDetailViewMainCard extends StatefulWidget {
  final int index;
  final OrderProduct productData;

  final Function(int) onCheckbox;

  const OrderDetailViewMainCard({Key key, this.index, this.productData, this.onCheckbox}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderDetailViewMainCardState();
}

class OrderDetailViewMainCardState extends State<OrderDetailViewMainCard> {
  List<DropdownMenuItem> subWarehouseList = [];
  @override
  void initState() {
    subWarehouseList = StaticVariables.subWarehouses
        .where((subWarehouse) =>
            subWarehouse.id == widget.productData.subWarehouseId ||
            subWarehouse.allowShopperAssign == '1' ||
            Services.isOperationManager())
        .map((subWarehouse) => DropdownMenuItem<dynamic>(
            child: AutoSizeText(subWarehouse.name,
                maxLines: 2, overflow: TextOverflow.fade, maxFontSize: 12, style: mainStyle),
            value: subWarehouse.id))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int purchasePrice =
        int.parse(widget.productData.pivot.purchasePrice.split('.')[0]) - widget.productData.pivot.increaseValue;
    double discountPercentage = SubWarehouse.getDiscountPercentage(widget.productData.subWarehouseId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ProductCheckWidget(
              product: widget.productData,
              preferLeftSide: !StaticVariables.preferLeftSide,
              productCount: widget.productData.pivot.quantity,
              productName: widget.productData.name,
              index: widget.index,
              onCheckbox: (index) => widget.onCheckbox(index),
            ), //right side
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => FullScreenImage(
                          imageUrl: widget.productData.images.isNotEmpty
                              ? StaticVariables.imagePrefixUrl + widget.productData.images[0].imageFileName
                              : '',
                          tag: 'generate_a_unique_tag'))),
              child: KCacheImage(
                tag: widget.index + int.parse(widget.productData.pivot.productId),
                image: widget.productData.images.isNotEmpty
                    ? StaticVariables.imagePrefixUrl + widget.productData.images[0].imageFileName
                    : '',
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.productData.name,
                      style: mainStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(widget.productData.quantity + ' ' + (widget.productData.unit ?? ''), style: darkBold),
                  Text(StringUtils().oCcy.format(purchasePrice) + ' ${StaticVariables.companyInformation.currency}',
                      style: paragraphStyle),
                  if (Services.isSuperAdmin() &&
                      purchasePrice - int.parse(widget.productData.pivot.purchasePrice.split('.')[0]) != 0)
                    Text(
                        StringUtils().oCcy.format(int.parse(widget.productData.pivot.purchasePrice.split('.')[0])) +
                            ' ${StaticVariables.companyInformation.currency}',
                        style: warningStyle),
                  if (Services.isSupplierManager())
                    Text(
                      StringUtils().oCcy.format(purchasePrice - (purchasePrice * discountPercentage)).toString() +
                          ' ${StaticVariables.companyInformation.currency}',
                      style: paragraphStyle,
                    ),
                  Text('كمية المستودع : ' + widget.productData.availableQuantity,
                      style: mainStyle.copyWith(color: kmColors)),
                  if ((!Services.isSupplierManager()) && subWarehouseList.isNotEmpty)
                    DropdownButton(
                      items: subWarehouseList,
                      onChanged: (a) {
                        OrderDetailsServices.updateOrder(
                            orderId: widget.productData.pivot.orderId,
                            context: context,
                            updateKey: 'sub_warehouse_id',
                            updateValue: a.toString(),
                            productId: widget.productData.pivot.productId);
                        setState(() => widget.productData.subWarehouseId = a);
                      },
                      hint: subWarehouseList
                          .firstWhere((subWarehouse) => subWarehouse.value == widget.productData.subWarehouseId,
                              orElse: () => subWarehouseList.firstWhere(
                                      (subWarehouse) => subWarehouse.value == widget.productData.pivot.subWarehouseId,
                                      orElse: () {
                                    subWarehouseList.clear();
                                    return const DropdownMenuItem<int>(child: Text('No element'), value: 0);
                                  }))
                          .child,
                    ),
                ],
              ),
            ),
            ProductCheckWidget(
              product: widget.productData,
              preferLeftSide: StaticVariables.preferLeftSide,
              productCount: widget.productData.pivot.quantity,
              productName: widget.productData.name,
              index: widget.index,
              onCheckbox: (index) => widget.onCheckbox(index),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
