import '../../../../core/core_importer.dart';
import 'import_product_activation_in_warehouse_use_case.dart';
import 'import_product_prices_in_warehouse_use_case.dart';
import 'pick_file_use_case.dart';
import 'update_price_rate_threshold_use_cases.dart';

class SubWarehouseManagerUseCases {
  final ImportProductActivationInWarehouseUseCase importProductActivationInWarehouseUseCase;
  final ImportProductPricesInWarehouseUseCase importProductPricesInWarehouseUseCase;
  final UpdatePriceRateThresholdUseCase updatePriceRateThresholdUseCase;
  final PickFileUseCase pickFileUseCase;

  SubWarehouseManagerUseCases({
    @required this.importProductActivationInWarehouseUseCase,
    @required this.importProductPricesInWarehouseUseCase,
    @required this.updatePriceRateThresholdUseCase,
    @required this.pickFileUseCase,
  }) : assert(
          importProductActivationInWarehouseUseCase != null &&
              updatePriceRateThresholdUseCase != null &&
              pickFileUseCase != null &&
              importProductPricesInWarehouseUseCase != null,
          'All use cases should ne initialized.',
        );
}
