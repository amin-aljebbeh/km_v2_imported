import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/change_order_status_response_entity.dart';

class ChangeOrderStatusUseCase {
  final OrdersRepository ordersRepository;

  ChangeOrderStatusUseCase({this.ordersRepository});

  Future<Either<Failure, ChangeOrderStatusResponseEntity>> call({int orderId, int statusId}) async {
    return await ordersRepository.changeOrderStatus(orderId: orderId, statusId: statusId);
  }
}
