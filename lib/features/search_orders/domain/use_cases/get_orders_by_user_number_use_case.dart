import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../repositories/search_orders_repository.dart';

class GetOrdersByUserNumberUseCase {
  final SearchOrdersRepository ordersRepository;

  GetOrdersByUserNumberUseCase({this.ordersRepository});

  Future<Either<Failure, List<OrderEntity>>> call({String phoneNumber, int pageNumber, CancelToken cancelToken}) async {
    return await ordersRepository.getOrdersByUserNumber(
        cancelToken: cancelToken, pageNumber: pageNumber, phoneNumber: phoneNumber);
  }
}
