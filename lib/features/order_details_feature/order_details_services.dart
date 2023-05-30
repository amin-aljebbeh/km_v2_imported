import '../../core/core_importer.dart';

List<DropdownMenuItem<dynamic>> subWarehousesItems({BuildContext context, int subWarehouseId}) {
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
