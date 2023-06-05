import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/order_details/domain/repositories/order_details_repository.dart';

import '../../../../core/core_importer.dart';

class DeleteImageFromOrderUseCase {
  final OrderDetailsRepository orderDetailsRepository;

  DeleteImageFromOrderUseCase({this.orderDetailsRepository});

  Future<Either<Failure, Unit>> call({int imageId}) async {
    return await orderDetailsRepository.deleteImageFromOrder(imageId: imageId);
  }
}
