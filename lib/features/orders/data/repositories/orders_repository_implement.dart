import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/entities/change_order_status_response_entity.dart';
import 'package:kammun_app/features/orders/domain/entities/lock_order_response_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/orders_page_data_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../data_sources/orders_remote_data_source.dart';

class OrdersRepositoryImplement implements OrdersRepository {
  final OrdersRemoteDataSource ordersRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  OrdersRepositoryImplement({this.ordersRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> reAssignOrder({int orderId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => ordersRemoteDataSource.reAssignOrder(orderId: orderId));
  }

  @override
  Future<Either<Failure, Unit>> updateOrderRating({int orderId, int deliveryRating}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => ordersRemoteDataSource.updateOrderRating(orderId: orderId, deliveryRating: deliveryRating));
  }

  @override
  Future<Either<Failure, Unit>> assignOrderToShopper({int assignedId, int orderId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => ordersRemoteDataSource.assignOrderToShopper(orderId: orderId, assignedId: assignedId));
  }

  @override
  Future<Either<Failure, ChangeOrderStatusResponseEntity>> changeOrderStatus({int orderId, int statusId}) async {
    try {
      ChangeOrderStatusResponseEntity response =
          await ordersRemoteDataSource.changeOrderStatus(orderId: orderId, statusId: statusId);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
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
  }) async {
    try {
      OrdersPageDataEntity orders = await ordersRemoteDataSource.getAllOrders(
        cancelToken: cancelToken,
        pageNumber: pageNumber,
        filterEvaluatedOrders: filterEvaluatedOrders,
        shopperId: shopperId,
        fromDate: fromDate,
        orderStatusId: orderStatusId,
        supportedCityId: supportedCityId,
        toDate: toDate,
        warehouseId: warehouseId,
      );
      return Right(orders);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, OrdersPageDataEntity>> getShopperOrders(
      {int orderStatusId, int pageNumber, CancelToken cancelToken}) async {
    try {
      OrdersPageDataEntity orders = await ordersRemoteDataSource.getShopperOrders(
          cancelToken: cancelToken, pageNumber: pageNumber, orderStatusId: orderStatusId);
      return Right(orders);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, OrdersPageDataEntity>> getSupplierOrders(
      {int orderStatusId, int pageNumber, CancelToken cancelToken}) async {
    try {
      OrdersPageDataEntity orders = await ordersRemoteDataSource.getSupplierOrders(
          cancelToken: cancelToken, pageNumber: pageNumber, orderStatusId: orderStatusId);
      return Right(orders);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, LockOrderResponseEntity>> lockOrder({int orderId}) async {
    try {
      LockOrderResponseEntity response = await ordersRemoteDataSource.lockOrder(orderId: orderId);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unlockOrder({int orderId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => ordersRemoteDataSource.unlockOrder(orderId: orderId));
  }
}
