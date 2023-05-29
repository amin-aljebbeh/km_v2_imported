import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class GetAllOrdersUseCase {
  final OrdersRepository ordersRepository;

  GetAllOrdersUseCase({this.ordersRepository});

  Future<Either<Failure, List<OrderModel>>> call(
      {int pageNumber, CancelToken cancelToken, int filterEvaluatedOrders}) async {
    return await ordersRepository.getAllOrders(
        cancelToken: cancelToken, pageNumber: pageNumber, filterEvaluatedOrders: filterEvaluatedOrders);
  }
}
