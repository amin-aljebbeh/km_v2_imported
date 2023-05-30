import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/get_order_response_entity.dart';
import '../repositories/search_orders_repository.dart';

class GetOrderUseCase {
  final SearchOrdersRepository ordersRepository;

  GetOrderUseCase({this.ordersRepository});

  Future<Either<Failure, GetOrderResponseEntity>> call({int orderId, CancelToken cancelToken}) async {
    return await ordersRepository.getOrder(cancelToken: cancelToken, orderId: orderId);
  }
}
