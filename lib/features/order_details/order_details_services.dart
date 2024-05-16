import 'dart:collection';

import 'package:kammun_app/features/order_details/presentation/pages/full_screen_image.dart';
import 'package:kammun_app/features/order_details/presentation/redux/order_details_action.dart';

import '../../core/core_importer.dart';
import '../general_information/data/models/sub_warehouse_model.dart';
import '../orders/domain/entities/order_entity.dart';
import '../orders/domain/entities/order_image_entity.dart';
import '../products/domain/entities/product_entity.dart';

List<DropdownMenuItem<dynamic>> subWarehousesItems({BuildContext context, int subWarehouseId, bool print = false}) {
  return StoreProvider.of<AppState>(context)
      .state
      .generalInformationState
      .subWarehouses
      .where((subWarehouse) =>
          subWarehouse.id == subWarehouseId ||
          subWarehouse.allowShopperAssign == '1' ||
          Services.hasRole(context, operationManagerRole))
      .map((subWarehouse) => DropdownMenuItem<dynamic>(
          child: AutoSizeText(subWarehouse.name,
              maxLines: 2, overflow: TextOverflow.fade, maxFontSize: 12, style: mainStyle),
          value: subWarehouse.id))
      .toList();
}

Map<int, List<ProductEntity>> getSubWarehousesProducts(
    {List<ProductEntity> products, bool deleted, BuildContext context}) {
  List<ProductEntity> productsAry = [];
  productsAry.addAll(products);
  if (deleted) {
    productsAry.removeWhere((product) => product.pivot.deletedAt == 'null');
    // remove remaining products and keep deleted
  } else {
    productsAry.removeWhere((product) => product.pivot.deletedAt != 'null');
    // remove deleted products and keep remaining
  }
  Map<int, List<ProductEntity>> subWarehousesProducts =
      productsAry.fold<Map<int, List<ProductEntity>>>({}, (map, product) {
    final subWarehouseId = product.pivot.subWarehouseId;

    if (!map.containsKey(subWarehouseId)) map[subWarehouseId] = [];
    map[subWarehouseId].add(product);

    return map;
  });

  var sortedMap = SplayTreeMap<int, List<ProductEntity>>.from(subWarehousesProducts, (a, b) => a.compareTo(b));

  return sortedMap;
}

List<ProductEntity> orderProducts({List<ProductEntity> products, bool deleted, BuildContext context}) {
  List<ProductEntity> productsAry = [];
  productsAry.addAll(products);
  if (deleted) {
    productsAry.removeWhere((product) => product.pivot.deletedAt == 'null');
  } else {
    productsAry.removeWhere((product) => product.pivot.deletedAt != 'null');
  }
  if (StoreProvider.of<AppState>(context).state.generalInformationState.subWarehouses.length == 1) {
    productsAry.sort((a, b) {
      if (a.pivot.subWarehouseId > b.pivot.subWarehouseId) {
        return -1;
      } else if (a.pivot.subWarehouseId < b.pivot.subWarehouseId) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    productsAry.sort((a, b) {
      if (a.pivot.subWarehouseId > b.pivot.subWarehouseId) {
        return 1;
      } else if (a.pivot.subWarehouseId < b.pivot.subWarehouseId) {
        return -1;
      } else {
        return 0;
      }
    });
  }
  return productsAry;
}

List<Widget> calculate({OrderEntity order, BuildContext context}) {
  List<Widget> subWarehouseTotal = [];
  subWarehouseTotal.add(KTableRow(
    children: [
      const KTableElement(text: 'المورد'),
      const KTableElement(text: 'الدفع للمورد'),
      if (Services.hasRole(context, accountingRole)) const KTableElement(text: 'نسبة الزيادة'),
      const KTableElement(text: 'السعر الصافي')
    ],
  ));
  if (order.orderAccountingRows != null) {
    for (int i = 0; i < order.orderAccountingRows.length; i++) {
      if (order.orderAccountingRows[i].payToSubWarehouse != 0) {
        subWarehouseTotal.add(KTableRow(
          children: [
            KTableElement(text: order.orderAccountingRows[i].subWarehouseName),
            KTableElement(
              text: StringUtils().oCcy.format(order.orderAccountingRows[i].directDiscount == 1
                  ? Services.kRound(order.orderAccountingRows[i].payToSubWarehouse)
                  : order.orderAccountingRows[i].payToSubWarehouse),
            ),
            if (Services.hasRole(context, accountingRole))
              KTableElement(text: StringUtils().oCcy.format(order.orderAccountingRows[i].increaseValuesSum)),
            KTableElement(text: StringUtils().oCcy.format(order.orderAccountingRows[i].netPrice)),
          ],
        ));
      }
    }
  }
  if (!Services.hasRole(context, supplierRole)) {
    int delivery = int.parse(order.supportedCityCost.split('.')[0]) +
        int.parse(order.deliveryCost.split('.')[0]) +
        int.parse(order.collectingCost.split('.')[0]);
    int subTotal = int.parse(order.total.split('.')[0]) - delivery;
    subWarehouseTotal.add(KTableRow(
        children: [KTableElement(text: subtotalString), KTableElement(text: StringUtils().oCcy.format(subTotal))]));
    subWarehouseTotal.add(KTableRow(children: [
      const KTableElement(text: 'أجور التوصيل'),
      KTableElement(text: StringUtils().oCcy.format(delivery))
    ]));
    if (order.tips != 0) {
      subWarehouseTotal.add(KTableRow(children: [
        const KTableElement(text: 'الإكرامية'),
        KTableElement(text: StringUtils().oCcy.format(order.tips))
      ]));
    }
    if (int.parse(order.couponValue.split('.')[0]) != 0) {
      subWarehouseTotal.add(KTableRow(children: [
        const KTableElement(text: 'قيمة كود الحسم'),
        KTableElement(
            text: StringUtils().oCcy.format(int.parse(order.couponValue.split('.')[0])), style: lightLoseStyle)
      ]));
    }
    if (int.parse(order.walletValue.split('.')[0]) != 0) {
      subWarehouseTotal.add(KTableRow(children: [
        const KTableElement(text: 'قيمة المحفظة'),
        KTableElement(
            text: StringUtils().oCcy.format(int.parse(order.walletValue.split('.')[0])), style: lightLoseStyle)
      ]));
    }
    subWarehouseTotal.add(KTableRow(children: [
      KTableElement(text: totalString),
      KTableElement(
          text: StringUtils()
              .oCcy
              .format(int.parse(order.total.split('.')[0]) - int.parse(order.walletValue.split('.')[0])))
    ]));
    subWarehouseTotal.add(KTableRow(children: [
      KTableElement(text: 'القبض من الزبون', style: informationStyle),
      KTableElement(
          text: StringUtils().oCcy.format(int.parse(order.cashValue.split('.')[0])),
          style: int.parse(order.cashValue.split('.')[0]).isNegative
              ? informationStyle.copyWith(color: Colors.red)
              : informationStyle)
    ]));
  } else {
    if (order.orderAccountingRows != null) {
      subWarehouseTotal.add(KTableRow(children: [
        KTableElement(text: totalString),
        KTableElement(
            text: StringUtils()
                .oCcy
                .format(Services.kRound(order.orderAccountingRows.fold(0, (sum, row) => sum + row.payToSubWarehouse))))
      ]));
    }
  }
  return subWarehouseTotal;
}

List<InkWell> getImages({List<OrderImageEntity> images, BuildContext context, Function(int) onDelete}) {
  List<InkWell> imageWidgets = [];
  for (int i = 0; i < images.length; i++) {
    imageWidgets.add(InkWell(
      onLongPress: () async {
        List<DialogButton> dialogButtons = [
          DialogButton(
            text: yes,
            onTap: () async {
              Navigator.of(context).pop();
              StoreProvider.of<AppState>(context).dispatch(
                  DeleteImageFromOrderAction(context: context, imageId: images[i].id, onDelete: () => onDelete(i)));
            },
          ),
          DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
        ];
        if (Services.hasRole(context, operationManagerRole)) {
          showMyDialog(context: context, title: '', text: 'هل تريد حذف الفاتورة ؟', dialogButtons: dialogButtons);
        }
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FullScreenImage(
                    imageUrl: StoreProvider.of<AppState>(context)
                            .state
                            .generalInformationState
                            .companyInformation
                            .imagePrefixUrl +
                        'orders/' +
                        images[i].imageFileName,
                    tag: 'generate_a_unique_tag')));
      },
      child: images != null && images.isNotEmpty
          ? KCacheImage(tag: images[i].imageFileName, image: 'orders/' + images[i].imageFileName)
          : const AssetImage('assets/kmIcon.png'),
    ));
  }
  return imageWidgets;
}

double getDiscountPercentage(int subWarehouseId, BuildContext context) => (StoreProvider.of<AppState>(context)
        .state
        .generalInformationState
        .subWarehouses
        .firstWhere((subWarehouse) => subWarehouse.id == subWarehouseId,
            orElse: () => SubWarehouseModel(discountPercentage: 1.0))
        .discountPercentage /
    100);

class OrderSubWarehouseProducts {}
