import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
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
}
