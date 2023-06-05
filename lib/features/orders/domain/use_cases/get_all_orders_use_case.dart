import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/order_entity.dart';

class GetAllOrdersUseCase {
  final OrdersRepository ordersRepository;

  GetAllOrdersUseCase({this.ordersRepository});

  Future<Either<Failure, List<OrderEntity>>> call(
      {int pageNumber, CancelToken cancelToken, int filterEvaluatedOrders}) async {
    return await ordersRepository.getAllOrders(
        cancelToken: cancelToken, pageNumber: pageNumber, filterEvaluatedOrders: filterEvaluatedOrders);
  }
}
