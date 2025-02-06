import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders/domain/entities/cancel_reason_entity.dart';
import 'package:kammun_app/features/orders/domain/repositories/orders_repository.dart';

import '../../../../core/core_importer.dart';

class GetCancelReasonsUseCase {
  final OrdersRepository ordersRepository;

  GetCancelReasonsUseCase({this.ordersRepository});

  Future<Either<Failure, List<CancelReasonEntity>>> call() async => await ordersRepository.getCancelReasons();
}
