import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/orders_page_data_entity.dart';

class GetAllOrdersUseCase {
  final OrdersRepository ordersRepository;

  GetAllOrdersUseCase({this.ordersRepository});

  Future<Either<Failure, OrdersPageDataEntity>> call({
    int pageNumber,
    CancelToken cancelToken,
    int filterEvaluatedOrders,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
    int isAssigned,
  }) async {
    return await ordersRepository.getAllOrders(
      cancelToken: cancelToken,
      pageNumber: pageNumber,
      filterEvaluatedOrders: filterEvaluatedOrders,
      warehouseId: warehouseId,
      toDate: toDate,
      supportedCityId: supportedCityId,
      orderStatusId: orderStatusId,
      fromDate: fromDate,
      shopperId: shopperId,
      isAssigned: isAssigned,
    );
  }
}
