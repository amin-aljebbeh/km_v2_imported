import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../entities/change_order_status_response_entity.dart';
import '../entities/lock_order_response_entity.dart';
import '../entities/orders_page_data_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrdersPageDataEntity>> getAllOrders({
    int pageNumber,
    int filterEvaluatedOrders,
    CancelToken cancelToken,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
    int isAssigned,
  });

  Future<Either<Failure, OrdersPageDataEntity>> getSupplierOrders(
      {int orderStatusId, int pageNumber, CancelToken cancelToken});

  Future<Either<Failure, OrdersPageDataEntity>> getShopperOrders(
      {int orderStatusId, int pageNumber, CancelToken cancelToken});

  Future<Either<Failure, ChangeOrderStatusResponseEntity>> changeOrderStatus({int orderId, int statusId});

  Future<Either<Failure, LockOrderResponseEntity>> lockOrder({int orderId});

  Future<Either<Failure, Unit>> unlockOrder({int orderId});

  Future<Either<Failure, Unit>> assignOrderToShopper({int assignedId, int orderId});

  Future<Either<Failure, Unit>> reAssignOrder({int orderId});

  Future<Either<Failure, Unit>> updateOrderRating({int orderId, int deliveryRating});
}
