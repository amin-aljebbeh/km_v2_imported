import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../repositories/order_details_repository.dart';

class AuthCodeOrderUserUseCase {
  final OrderDetailsRepository orderDetailsRepository;

  AuthCodeOrderUserUseCase({this.orderDetailsRepository});

  Future<Either<Failure, Unit>> call({String code, int orderId , int subWareHouseId}) async {
    return await orderDetailsRepository.authCodeOrder(orderId: orderId, code: code,subWareHouseId: subWareHouseId);
  }
}
