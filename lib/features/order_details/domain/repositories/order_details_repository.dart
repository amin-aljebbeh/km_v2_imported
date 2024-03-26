import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class OrderDetailsRepository {
  Future<Either<Failure, Unit>> updateOrderProduct({int orderId, String updateKey, String updateValue, int productId});

  Future<Either<Failure, Unit>> addImageToOrder({int orderId, File image});

  Future<Either<Failure, Unit>> deleteImageFromOrder({int imageId});
  Future<Either<Failure, Unit>> authCodeOrder({ int orderId, String code , int subWareHouseId});

}
