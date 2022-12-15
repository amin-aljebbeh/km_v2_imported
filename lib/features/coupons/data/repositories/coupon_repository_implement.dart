import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../data_sources/coupon_remote_data_source.dart';
import '../models/coupon_model.dart';

class CouponsRepositoryImplement implements CouponsRepository {
  final CouponRemoteDataSource couponRemoteDataSource;

  CouponsRepositoryImplement({this.couponRemoteDataSource});
  @override
  Future<Either<Failure, List<CouponModel>>> getCoupons({int isGeneral, int isForDelivery, String code}) async {
    try {
      List<CouponModel> coupons =
          await couponRemoteDataSource.getCoupons(isGeneral: isGeneral, isForDelivery: isForDelivery, code: code);
      return Right(coupons);
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
