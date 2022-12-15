import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/coupons/domain/entities/get_coupons_response_entity.dart';

import '../../../../core/core_importer.dart';

abstract class CouponsRepository {
  Future<Either<Failure, GetCouponsResponseEntity>> getCoupons(
      {int isGeneral, int isForDelivery, String code, int page});
}
