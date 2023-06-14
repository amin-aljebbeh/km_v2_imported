import '../core/core_importer.dart';
import '../features/products_filter/data/data_sources/products_filter_remote_data_source.dart';
import '../features/products_filter/data/repositories/products_filter_repository_implement.dart';
import '../features/products_filter/domain/repositories/products_filter_repository.dart';
import '../features/products_filter/domain/use_cases/products_filter_use_cases.dart';

Future<void> injectProductsFilter() async {
  sl.registerLazySingleton<ProductsFilterUseCases>(() => ProductsFilterUseCases());
  sl.registerLazySingleton<ProductsFilterRepository>(
      () => ProductsFilterRepositoryImplement(productsFilterRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<ProductsFilterRemoteDataSource>(() => ProductsFilterRemoteDataSourceImplement());
}
