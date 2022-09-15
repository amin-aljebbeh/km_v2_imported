import 'package:dartz/dartz.dart';
import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';

abstract class InventoryRepository {
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts({int pageNumber});
}
