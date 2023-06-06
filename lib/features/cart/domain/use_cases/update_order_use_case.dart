import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/cart/domain/repositories/cart_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/submit_order_entity.dart';
import '../entities/update_order_response_entity.dart';

class UpdateOrderUseCase {
  final CartRepository cartRepository;

  UpdateOrderUseCase({this.cartRepository});

  Future<Either<Failure, UpdateOrderResponseEntity>> call({int orderId, SubmitOrderEntity submitOrderEntity}) async {
    return await cartRepository.updateOrder(orderId: orderId, submitOrderEntity: submitOrderEntity);
  }
}
