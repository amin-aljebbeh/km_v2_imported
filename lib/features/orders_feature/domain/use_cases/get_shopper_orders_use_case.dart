import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class GetShopperOrdersUseCase {
  final OrdersRepository ordersRepository;

  GetShopperOrdersUseCase({this.ordersRepository});

  Future<Either<Failure, List<OrderModel>>> call({int pageNumber, CancelToken cancelToken}) async {
    return await ordersRepository.getShopperOrders(cancelToken: cancelToken, pageNumber: pageNumber);
  }
}
