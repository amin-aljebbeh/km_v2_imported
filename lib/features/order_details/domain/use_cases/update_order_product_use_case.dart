import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/order_details/domain/repositories/order_details_repository.dart';

import '../../../../core/core_importer.dart';

class UpdateOrderProductUseCase {
  final OrderDetailsRepository orderDetailsRepository;

  UpdateOrderProductUseCase({this.orderDetailsRepository});

  Future<Either<Failure, Unit>> call({int orderId, String updateKey, String updateValue, int productId}) async {
    return await orderDetailsRepository.updateOrderProduct(
        orderId: orderId, productId: productId, updateValue: updateValue, updateKey: updateKey);
  }
}
