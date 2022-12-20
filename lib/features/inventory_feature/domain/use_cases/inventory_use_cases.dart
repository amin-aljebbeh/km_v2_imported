import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_prime_products_use_case.dart';

class InventoryUseCase {
  final GetNotificationProductsUseCase getNotificationProductsUseCase;
  final GetPrimeProductsUseCase getPrimeProductsUseCase;

  InventoryUseCase({@required this.getPrimeProductsUseCase, @required this.getNotificationProductsUseCase})
      : assert(getNotificationProductsUseCase != null && getPrimeProductsUseCase != null,
            'All use cases should ne initialized.');
}
