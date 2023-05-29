import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/coupons/domain/entities/coupon_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/get_coupons_response_entity.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../data_sources/coupon_remote_data_source.dart';

class CouponsRepositoryImplement implements CouponsRepository {
  final CouponRemoteDataSource couponRemoteDataSource;

  CouponsRepositoryImplement({this.couponRemoteDataSource});
  @override
  Future<Either<Failure, GetCouponsResponseEntity>> getCoupons(
      {int isGeneral, int isForDelivery, String code, int page}) async {
    try {
      GetCouponsResponseEntity coupons = await couponRemoteDataSource.getCoupons(
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

  @override
  Future<Either<Failure, List<CouponEntity>>> getUserCoupons({int userId}) async {
    try {
      List<CouponEntity> coupons = await couponRemoteDataSource.getUserCoupons(userId: userId);
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
