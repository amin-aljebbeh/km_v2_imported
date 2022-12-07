import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';

class InventoryUseCase {
  final GetNotificationProductsUseCase getNotificationProductsUseCase;

  InventoryUseCase({@required this.getNotificationProductsUseCase})
      : assert(getNotificationProductsUseCase != null, 'All use cases should ne initialized.');
}
