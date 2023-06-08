import '../../../../core/core_importer.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_inventory_data_source.dart';

class HomeRepositoryImplement implements HomeRepository {
  final HomeRemoteDataSource homeInventoryDataSource;
  final RepositoryFactory repositoryFactory;

  HomeRepositoryImplement({this.homeInventoryDataSource, this.repositoryFactory});
}
