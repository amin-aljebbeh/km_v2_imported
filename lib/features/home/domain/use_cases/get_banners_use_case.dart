import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/home/domain/entities/banner_entity.dart';
import 'package:kammun_app/features/home/domain/repositories/home_repository.dart';

import '../../../../core/core_importer.dart';

class GetBannersUseCase {
  final HomeRepository homeRepository;

  GetBannersUseCase({this.homeRepository});

  Future<Either<Failure, List<BannerEntity>>> call() async {
    return await homeRepository.getBanners();
  }
}
