import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/home/domain/entities/banner_entity.dart';

import '../../../../core/core_importer.dart';

abstract class HomeRepository {
  Future<Either<Failure,List<BannerEntity>>>getBanners();
}
