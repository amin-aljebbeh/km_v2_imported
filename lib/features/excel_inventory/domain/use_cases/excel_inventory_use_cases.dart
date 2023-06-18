import '../../../../core/core_importer.dart';
import 'import_product_activation_in_warehouse_use_case.dart';
import 'import_product_prices_in_warehouse_use_case.dart';

class ExcelInventoryUseCases {
  final ImportProductActivationInWarehouseUseCase importProductActivationInWarehouseUseCase;
  final ImportProductPricesInWarehouseUseCase importProductPricesInWarehouseUseCase;

  ExcelInventoryUseCases(
      {@required this.importProductActivationInWarehouseUseCase, @required this.importProductPricesInWarehouseUseCase})
      : assert(importProductActivationInWarehouseUseCase != null && importProductPricesInWarehouseUseCase != null,
            'All use cases should ne initialized.');
}
