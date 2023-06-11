import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_prime_products_use_case.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_under_check_availability_use_case.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/keeping_inventories_record_use_cases.dart';

import 'get_added_products_use_cases.dart';
import 'get_all_products_use_cases.dart';
import 'get_not_added_products_use_cases.dart';
import 'target_inventory_use_case.dart';

class InventoryUseCase {
  final GetNotificationProductsUseCase getNotificationProductsUseCase;
  final GetNotAddedProductsUseCase getNotAddedProductsUseCase;
  final GetAddedProductsUseCase getAddedProductsUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetPrimeProductsUseCase getPrimeProductsUseCase;
  final GetUnderCheckAvailabilityUseCase getUnderCheckAvailabilityUseCase;
  final TargetInventoryUseCase targetInventoryUseCase;
  final KeepingInventoriesRecordUseCase keepingInventoriesRecordUseCase;

  InventoryUseCase({
    @required this.getPrimeProductsUseCase,
    @required this.getNotificationProductsUseCase,
    @required this.getUnderCheckAvailabilityUseCase,
    @required this.targetInventoryUseCase,
    @required this.keepingInventoriesRecordUseCase,
    @required this.getNotAddedProductsUseCase,
    @required this.getAddedProductsUseCase,
    @required this.getAllProductsUseCase,
  }) : assert(
          getNotificationProductsUseCase != null &&
              getPrimeProductsUseCase != null &&
              targetInventoryUseCase != null &&
              getNotAddedProductsUseCase != null &&
              getAddedProductsUseCase != null &&
              getAllProductsUseCase != null &&
              keepingInventoriesRecordUseCase != null &&
              getUnderCheckAvailabilityUseCase != null,
          'All use cases should ne initialized.',
        );
}
