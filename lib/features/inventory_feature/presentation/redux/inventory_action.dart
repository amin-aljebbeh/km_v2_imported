import '../../../../core/core_importer.dart';

class GetNotificationProducts {}

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
