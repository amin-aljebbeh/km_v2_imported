import 'package:kammun_app/features/shoppers/data/data_sources/shoppers_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/shoppers_repository.dart';

class ShoppersRepositoryImplement extends ShoppersRepository {
  final ShoppersRemoteDataSource shoppersRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ShoppersRepositoryImplement({this.shoppersRemoteDataSource, this.repositoryFactory});
}
