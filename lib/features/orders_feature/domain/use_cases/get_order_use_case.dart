import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/get_order_response_entity.dart';

class GetOrderUseCase {
  final OrdersRepository ordersRepository;

  GetOrderUseCase({this.ordersRepository});

  Future<Either<Failure, GetOrderResponseEntity>> call({int orderId, CancelToken cancelToken}) async {
    return await ordersRepository.getOrder(cancelToken: cancelToken, orderId: orderId);
  }
}
