import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class UpdateOrderRatingUseCase {
  final OrdersRepository ordersRepository;

  UpdateOrderRatingUseCase({this.ordersRepository});
  Future<Either<Failure, Unit>> call({int orderId, int deliveryRating}) async {
    return await ordersRepository.updateOrderRating(orderId: orderId, deliveryRating: deliveryRating);
  }
}
