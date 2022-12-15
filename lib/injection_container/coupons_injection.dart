import 'package:kammun_app/features/coupons/domain/repositories/coupon_repository.dart';
import 'package:kammun_app/features/coupons/domain/use_cases/coupon_use_cases.dart';
import 'package:kammun_app/features/coupons/domain/use_cases/get_coupons_use_case.dart';

import '../core/core_importer.dart';
import '../features/coupons/data/data_sources/coupon_remote_data_source.dart';
import '../features/coupons/data/repositories/coupon_repository_implement.dart';

Future<void> injectCoupons() async {
  sl.registerLazySingleton(() => GetCouponsUseCase(couponRepository: sl()));
  sl.registerLazySingleton<CouponsUseCases>(() => CouponsUseCases(getCouponsUseCase: sl()));
  sl.registerLazySingleton<CouponsRepository>(() => CouponsRepositoryImplement(couponRemoteDataSource: sl()));
  sl.registerLazySingleton<CouponRemoteDataSource>(() => CouponRemoteDataSourceImplement());
}
