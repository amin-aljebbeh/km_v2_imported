import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/order_details/data/data_sources/order_details_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/order_details_repository.dart';

class OrderDetailsRepositoryImplement implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource orderDetailsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  OrderDetailsRepositoryImplement({this.orderDetailsRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> addImageToOrder({int orderId, File image}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => orderDetailsRemoteDataSource.addImageToOrder(orderId: orderId, image: image));
  }

  @override
  Future<Either<Failure, Unit>> deleteImageFromOrder({int imageId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => orderDetailsRemoteDataSource.deleteImageFromOrder(imageId: imageId));
  }

  @override
  Future<Either<Failure, Unit>> updateOrderProduct(
      {int orderId, String updateKey, String updateValue, int productId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => orderDetailsRemoteDataSource.updateOrderProduct(
            orderId: orderId, productId: productId, updateKey: updateKey, updateValue: updateValue));
  }
}
