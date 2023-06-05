import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:kammun_app/features/search_orders/domain/entities/get_order_response_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/search_orders_repository.dart';
import '../data_sources/search_orders_remote_data_source.dart';

class SearchOrdersRepositoryImplement implements SearchOrdersRepository {
  final SearchOrdersRemoteDataSource ordersRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  SearchOrdersRepositoryImplement({this.ordersRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, GetOrderResponseEntity>> getOrder({int orderId, CancelToken cancelToken}) async {
    try {
      GetOrderResponseEntity response =
          await ordersRemoteDataSource.getOrder(cancelToken: cancelToken, orderId: orderId);
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
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserNumber(
      {String phoneNumber, int pageNumber, CancelToken cancelToken}) async {
    try {
      List<OrderEntity> orders = await ordersRemoteDataSource.getOrdersByUserNumber(
          cancelToken: cancelToken, pageNumber: pageNumber, phoneNumber: phoneNumber);
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
}
