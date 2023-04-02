import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

abstract class OrdersRepository {
  Future<Either<Failure, Unit>> reAssignOrder({int orderId});
  Future<Either<Failure, Unit>> updateOrderRating({int orderId, int deliveryRating});
}
