import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../data_sources/coupon_remote_data_source.dart';
import '../models/get_coupons_model.dart';

class CouponsRepositoryImplement implements CouponsRepository {
  final CouponRemoteDataSource couponRemoteDataSource;

  CouponsRepositoryImplement({this.couponRemoteDataSource});
  @override
  Future<Either<Failure, GetCouponsResponseModel>> getCoupons(
      {int isGeneral, int isForDelivery, String code, int page}) async {
    try {
      GetCouponsResponseModel coupons = await couponRemoteDataSource.getCoupons(
          isGeneral: isGeneral, isForDelivery: isForDelivery, code: code, page: page);
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
