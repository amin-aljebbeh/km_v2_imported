import '../../core/core_importer.dart';

List<DropdownMenuItem<dynamic>> subWarehousesItems({BuildContext context, int subWarehouseId, bool print = false}) {
  return StaticVariables.subWarehouses
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

List<OrderProduct> orderProducts({List<OrderProduct> products, bool deleted}) {
  List<OrderProduct> productsAry = [];
  productsAry.addAll(products);
  if (deleted) {
    productsAry.removeWhere((product) => product.pivot.deletedAt == 'null');
  } else {
    productsAry.removeWhere((product) => product.pivot.deletedAt != 'null');
  }
  if (StaticVariables.subWarehouses.length == 1) {
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

double kRound(double number) {
  double doubleSum = number / 100;
  String stringSum = doubleSum.toString().split('.')[0];
  double result = double.parse(stringSum);
  result *= 100;
  return result;
}
