import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/get_error_orders_use_case.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/get_notification_products_use_cases.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/get_prime_products_use_case.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/get_under_check_availability_use_case.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/keeping_inventories_record_use_cases.dart';
import 'package:kammun_app/features/inventory/domain/use_cases/search_product_by_barcode_use_cases.dart';

import 'check_product_barcode_use_cases.dart';
import 'get_added_products_use_cases.dart';
import 'get_all_products_use_cases.dart';
import 'get_not_added_products_use_cases.dart';
import 'get_price_changes_use_cases.dart';
import 'get_sub_warehouse_products_use_cases.dart';
import 'target_inventory_use_case.dart';

class InventoryUseCase {
  final GetNotificationProductsUseCase getNotificationProductsUseCase;
  final GetNotAddedProductsUseCase getNotAddedProductsUseCase;
  final GetAddedProductsUseCase getAddedProductsUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetPrimeProductsUseCase getPrimeProductsUseCase;
  final GetErrorProductsUseCase getErrorProductsUseCase;
  final GetUnderCheckAvailabilityUseCase getUnderCheckAvailabilityUseCase;
  final CheckProductsBarcodeUseCase checkProductsBarcodeUseCase;
  final SearchProductByBarcodeUseCase searchProductByBarcodeUseCase;
  final GetPriceChangesUseCase getPriceChangesUseCase;
  final TargetInventoryUseCase targetInventoryUseCase;
  final KeepingInventoriesRecordUseCase keepingInventoriesRecordUseCase;
  final GetSubWarehouseProductsUseCase getSubWarehouseProductsUseCase;

  InventoryUseCase({
    @required this.getErrorProductsUseCase,
    @required this.getPrimeProductsUseCase,
    @required this.getNotificationProductsUseCase,
    @required this.getUnderCheckAvailabilityUseCase,
    @required this.targetInventoryUseCase,
    @required this.keepingInventoriesRecordUseCase,
    @required this.getNotAddedProductsUseCase,
    @required this.getAddedProductsUseCase,
    @required this.getAllProductsUseCase,
    @required this.checkProductsBarcodeUseCase,
    @required this.searchProductByBarcodeUseCase,
    @required this.getSubWarehouseProductsUseCase,
    @required this.getPriceChangesUseCase,
  }) : assert(
          getErrorProductsUseCase != null &&
              getNotificationProductsUseCase != null &&
              getPrimeProductsUseCase != null &&
              targetInventoryUseCase != null &&
              checkProductsBarcodeUseCase != null &&
              getPriceChangesUseCase != null &&
              searchProductByBarcodeUseCase != null &&
              getNotAddedProductsUseCase != null &&
              getAddedProductsUseCase != null &&
              getSubWarehouseProductsUseCase != null &&
              getAllProductsUseCase != null &&
              keepingInventoriesRecordUseCase != null &&
              getUnderCheckAvailabilityUseCase != null,
          'All use cases should ne initialized.',
        );
}
