import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/orders_page_data_entity.dart';

class GetSupplierOrdersUseCase {
  final OrdersRepository ordersRepository;

  GetSupplierOrdersUseCase({this.ordersRepository});

  Future<Either<Failure, OrdersPageDataEntity>> call(
      {int orderStatusId, int pageNumber, CancelToken cancelToken}) async {
    return await ordersRepository.getSupplierOrders(
        cancelToken: cancelToken, pageNumber: pageNumber, orderStatusId: orderStatusId);
  }
}
