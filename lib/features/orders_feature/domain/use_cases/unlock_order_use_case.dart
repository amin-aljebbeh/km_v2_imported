import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class UnlockOrderUseCase {
  final OrdersRepository ordersRepository;

  UnlockOrderUseCase({this.ordersRepository});

  Future<Either<Failure, Unit>> call({int orderId}) async {
    return await ordersRepository.unlockOrder(orderId: orderId);
  }
}
