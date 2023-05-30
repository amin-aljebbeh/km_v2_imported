import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';

import '../../../../core/core_importer.dart';
import '../repositories/search_orders_repository.dart';

class GetOrdersByUserNumberUseCase {
  final SearchOrdersRepository ordersRepository;

  GetOrdersByUserNumberUseCase({this.ordersRepository});

  Future<Either<Failure, List<OrderModel>>> call({String phoneNumber, int pageNumber, CancelToken cancelToken}) async {
    return await ordersRepository.getOrdersByUserNumber(
        cancelToken: cancelToken, pageNumber: pageNumber, phoneNumber: phoneNumber);
  }
}
