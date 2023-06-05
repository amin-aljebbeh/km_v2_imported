import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class AssignOrderToShopperUseCase {
  final OrdersRepository ordersRepository;

  AssignOrderToShopperUseCase({this.ordersRepository});

  Future<Either<Failure, Unit>> call({int orderId, int assignedId}) async {
    return await ordersRepository.assignOrderToShopper(orderId: orderId, assignedId: assignedId);
  }
}
