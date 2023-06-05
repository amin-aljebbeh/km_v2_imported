import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/lock_order_response_entity.dart';

class LockOrderUseCase {
  final OrdersRepository ordersRepository;

  LockOrderUseCase({this.ordersRepository});

  Future<Either<Failure, LockOrderResponseEntity>> call({int orderId}) async {
    return await ordersRepository.lockOrder(orderId: orderId);
  }
}
