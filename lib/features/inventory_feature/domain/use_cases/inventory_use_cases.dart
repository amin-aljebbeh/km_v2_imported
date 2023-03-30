import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_prime_products_use_case.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_under_check_availability_use_case.dart';

import 'target_inventory_use_case.dart';

class InventoryUseCase {
  final GetNotificationProductsUseCase getNotificationProductsUseCase;
  final GetPrimeProductsUseCase getPrimeProductsUseCase;
  final GetUnderCheckAvailabilityUseCase getUnderCheckAvailabilityUseCase;
  final TargetInventoryUseCase targetInventoryUseCase;

  InventoryUseCase({
    @required this.getPrimeProductsUseCase,
    @required this.getNotificationProductsUseCase,
    @required this.getUnderCheckAvailabilityUseCase,
    @required this.targetInventoryUseCase,
  }) : assert(
          getNotificationProductsUseCase != null &&
              getPrimeProductsUseCase != null &&
              targetInventoryUseCase != null &&
              getUnderCheckAvailabilityUseCase != null,
          'All use cases should ne initialized.',
        );
}
