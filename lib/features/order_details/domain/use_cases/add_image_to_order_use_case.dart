import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/order_details/domain/repositories/order_details_repository.dart';

import '../../../../core/core_importer.dart';

class AddImageToOrderUseCase {
  final OrderDetailsRepository orderDetailsRepository;

  AddImageToOrderUseCase({this.orderDetailsRepository});

  Future<Either<Failure, Unit>> call({int orderId, File image}) async {
    return await orderDetailsRepository.addImageToOrder(orderId: orderId, image: image);
  }
}
