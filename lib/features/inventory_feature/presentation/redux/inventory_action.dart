import '../../../../core/core_importer.dart';

class GetInventory {}

class GetNotificationProductsAction {}

class GetPrimeProductsAction {}

class GetUnderCheckAvailabilityAction {}

class SetInventoryProducts {
  final List<ProductData> products;

  SetInventoryProducts({this.products});
}

class ClearInventory {}

class SetSearchFilter {
  final String searchFilter;

  SetSearchFilter({this.searchFilter});
}

class EndOfProducts {}

class NextPage {}

class SetInventoryType {
  final InventoryTypes inventoryType;

  SetInventoryType({this.inventoryType});
}

class SetSubWarehouseId {
  final int subWarehouseId;

  SetSubWarehouseId({this.subWarehouseId});
}

class SetIsActive {
  final int isActive;

  SetIsActive({this.isActive});
}

class TargetInventoryAction {
  final BuildContext context;
  TargetInventoryAction({this.context});
}

class KeepingInventoriesRecordAction {
  final BuildContext context;
  KeepingInventoriesRecordAction({this.context});
}
