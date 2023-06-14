import 'package:kammun_app/features/products_filter/data/data_sources/products_filter_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/products_filter_repository.dart';

class ProductsFilterRepositoryImplement implements ProductsFilterRepository {
  final ProductsFilterRemoteDataSource productsFilterRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ProductsFilterRepositoryImplement({this.productsFilterRemoteDataSource, this.repositoryFactory});
}
