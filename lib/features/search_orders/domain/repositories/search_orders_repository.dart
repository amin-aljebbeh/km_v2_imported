import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../../orders/domain/entities/order_entity.dart';
import '../../../search_orders/domain/entities/get_order_response_entity.dart';

abstract class SearchOrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserNumber(
      {String phoneNumber, int pageNumber, CancelToken cancelToken});

  Future<Either<Failure, GetOrderResponseEntity>> getOrder({int orderId, CancelToken cancelToken});
}
